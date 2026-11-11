import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:greenlife_app/config/app_config.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/models/growth_note.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

Plant _plant({
  String id = 'custom-1',
  bool inGarden = true,
  List<String> tags = const ['indoor', 'easy'],
}) {
  return Plant(
    id: id,
    name: 'Cây thử',
    scientificName: 'Testus plantus',
    category: 'Indoor',
    description: 'Mô tả',
    careLevel: 'Easy',
    waterNeed: 'Weekly',
    sunlight: 'Indirect light',
    imageAsset: 'assets/a.png',
    imageUrl: 'https://example.com/a.png',
    isFavorite: true,
    inGarden: inGarden,
    plantedDate: '01/02/2026',
    careNotes: 'Gần cửa sổ',
    tags: tags,
  );
}

void main() {
  final storage = StorageService.instance;

  setUpAll(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  setUp(() async {
    await storage.clearAll();
  });

  group('tasks', () {
    test('loadTasks returns null when nothing was saved', () async {
      expect(await storage.loadTasks(), isNull);
    });

    test('saveTasks and loadTasks round-trip every field', () async {
      final dueAt = DateTime(2026, 11, 20, 8, 30);
      await storage.saveTasks([
        CareTask(
          id: 't1',
          title: 'Tưới nước',
          plantName: 'Trầu bà',
          type: 'watering',
          dueDate: '20/11/2026, 08:30',
          isCompleted: true,
          dueAt: dueAt,
          recurrence: CareTaskRecurrence.everyThreeDays,
        ),
        const CareTask(
          id: 't2',
          title: 'Khác',
          plantName: 'Sen đá',
          type: 'other',
          dueDate: '',
        ),
      ]);

      final loaded = await storage.loadTasks();

      expect(loaded, isNotNull);
      expect(loaded!.length, 2);
      expect(loaded[0].id, 't1');
      expect(loaded[0].title, 'Tưới nước');
      expect(loaded[0].plantName, 'Trầu bà');
      expect(loaded[0].type, 'watering');
      expect(loaded[0].dueDate, '20/11/2026, 08:30');
      expect(loaded[0].isCompleted, isTrue);
      expect(loaded[0].dueAt, dueAt);
      expect(loaded[0].recurrence, CareTaskRecurrence.everyThreeDays);
      expect(loaded[1].dueAt, isNull);
      expect(loaded[1].isCompleted, isFalse);
      expect(loaded[1].recurrence, CareTaskRecurrence.none);
    });

    test('an empty list is saved as an empty list, not null', () async {
      await storage.saveTasks(const []);

      expect(await storage.loadTasks(), isEmpty);
    });

    test('missing fields fall back to defaults and unknown recurrence to none',
        () async {
      await SharedPreferencesAsync().setString(
        AppConfig.tasksStorageKey,
        jsonEncode([
          {'id': 'x', 'recurrence': 'every-full-moon', 'dueAt': 'not a date'},
        ]),
      );

      final loaded = await storage.loadTasks();

      expect(loaded!.single.id, 'x');
      expect(loaded.single.title, '');
      expect(loaded.single.dueAt, isNull);
      expect(loaded.single.isCompleted, isFalse);
      expect(loaded.single.recurrence, CareTaskRecurrence.none);
    });

    test('corrupted or non-list JSON is treated as no data', () async {
      final prefs = SharedPreferencesAsync();

      await prefs.setString(AppConfig.tasksStorageKey, '{not json');
      expect(await storage.loadTasks(), isNull);

      await prefs.setString(AppConfig.tasksStorageKey, '{"a": 1}');
      expect(await storage.loadTasks(), isNull);
    });

    test('entries that are not objects are skipped', () async {
      await SharedPreferencesAsync().setString(
        AppConfig.tasksStorageKey,
        jsonEncode([
          'junk',
          42,
          {'id': 'ok'},
        ]),
      );

      final loaded = await storage.loadTasks();

      expect(loaded!.map((t) => t.id), ['ok']);
    });
  });

  group('plants', () {
    test('loadPlants returns null when nothing was saved', () async {
      expect(await storage.loadPlants(), isNull);
    });

    test('savePlants and loadPlants round-trip every field', () async {
      await storage.savePlants([_plant()]);

      final loaded = (await storage.loadPlants())!.single;

      expect(loaded.id, 'custom-1');
      expect(loaded.name, 'Cây thử');
      expect(loaded.scientificName, 'Testus plantus');
      expect(loaded.category, 'Indoor');
      expect(loaded.description, 'Mô tả');
      expect(loaded.careLevel, 'Easy');
      expect(loaded.waterNeed, 'Weekly');
      expect(loaded.sunlight, 'Indirect light');
      expect(loaded.imageAsset, 'assets/a.png');
      expect(loaded.imageUrl, 'https://example.com/a.png');
      expect(loaded.isFavorite, isTrue);
      expect(loaded.inGarden, isTrue);
      expect(loaded.plantedDate, '01/02/2026');
      expect(loaded.careNotes, 'Gần cửa sổ');
      expect(loaded.tags, ['indoor', 'easy']);
    });

    test('inGarden=false is preserved', () async {
      await storage.savePlants([_plant(id: 'plant-5', inGarden: false)]);

      expect((await storage.loadPlants())!.single.inGarden, isFalse);
    });

    test('tags that are missing or contain non-strings are cleaned up',
        () async {
      await SharedPreferencesAsync().setString(
        AppConfig.plantsStorageKey,
        jsonEncode([
          {
            'id': 'a',
            'tags': ['ok', 1, null],
          },
          {'id': 'b', 'tags': 'not a list'},
          {'id': 'c'},
        ]),
      );

      final loaded = (await storage.loadPlants())!;

      expect(loaded[0].tags, ['ok']);
      expect(loaded[1].tags, isEmpty);
      expect(loaded[2].tags, isEmpty);
    });

    test('legacy data without inGarden: user plants and the 4 starter plants '
        'are in the garden, other catalog plants are not', () async {
      await SharedPreferencesAsync().setString(
        AppConfig.plantsStorageKey,
        jsonEncode([
          {'id': 'my-own-plant'},
          {'id': 'plant-10'},
          {'id': 'plant-1'},
          {'id': 'plant-4'},
          {'id': 'plant-5'},
          {'id': 'plant-9'},
        ]),
      );

      final loaded = (await storage.loadPlants())!;
      final byId = {for (final p in loaded) p.id: p.inGarden};

      expect(byId['my-own-plant'], isTrue);
      expect(byId['plant-10'], isTrue);
      expect(byId['plant-1'], isTrue);
      expect(byId['plant-4'], isTrue);
      expect(byId['plant-5'], isFalse);
      expect(byId['plant-9'], isFalse);
    });
  });

  group('notes', () {
    test('loadNotes returns null when nothing was saved', () async {
      expect(await storage.loadNotes(), isNull);
    });

    test('saveNotes and loadNotes round-trip every field', () async {
      await storage.saveNotes(const [
        GrowthNote(
          id: 'n1',
          plantName: 'Trầu bà',
          title: 'Lá mới',
          date: '18/10/2026',
          summary: 'Cây phát triển tốt',
          imagePath: '/tmp/photo.jpg',
        ),
      ]);

      final loaded = (await storage.loadNotes())!.single;

      expect(loaded.id, 'n1');
      expect(loaded.plantName, 'Trầu bà');
      expect(loaded.title, 'Lá mới');
      expect(loaded.date, '18/10/2026');
      expect(loaded.summary, 'Cây phát triển tốt');
      expect(loaded.imagePath, '/tmp/photo.jpg');
    });

    test('missing fields fall back to empty strings', () async {
      await SharedPreferencesAsync().setString(
        AppConfig.notesStorageKey,
        jsonEncode([
          {'id': 'n'},
        ]),
      );

      final loaded = (await storage.loadNotes())!.single;

      expect(loaded.id, 'n');
      expect(loaded.title, '');
      expect(loaded.imagePath, '');
    });
  });

  group('locale and clearAll', () {
    test('locale code round-trips and is null before being saved', () async {
      expect(await storage.loadLocaleCode(), isNull);

      await storage.saveLocaleCode('en');
      expect(await storage.loadLocaleCode(), 'en');

      await storage.saveLocaleCode('vi');
      expect(await storage.loadLocaleCode(), 'vi');
    });

    test('clearAll removes tasks, plants, notes and locale', () async {
      await storage.saveTasks(const [
        CareTask(id: 't', title: '', plantName: '', type: '', dueDate: ''),
      ]);
      await storage.savePlants([_plant()]);
      await storage.saveNotes(const [
        GrowthNote(id: 'n', plantName: '', title: '', date: '', summary: ''),
      ]);
      await storage.saveLocaleCode('en');

      await storage.clearAll();

      expect(await storage.loadTasks(), isNull);
      expect(await storage.loadPlants(), isNull);
      expect(await storage.loadNotes(), isNull);
      expect(await storage.loadLocaleCode(), isNull);
    });
  });
}
