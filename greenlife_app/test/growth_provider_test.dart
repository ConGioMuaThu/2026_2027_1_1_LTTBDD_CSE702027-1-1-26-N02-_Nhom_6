import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/models/growth_note.dart';
import 'package:greenlife_app/providers/growth_provider.dart';
import 'package:greenlife_app/repositories/growth_repository.dart';
import 'package:greenlife_app/services/storage_service.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

GrowthNote _note(
  String id, {
  String date = '01/01/2030',
  String plantName = 'Cây thử',
  String title = 'Tiêu đề',
}) {
  return GrowthNote(
    id: id,
    plantName: plantName,
    title: title,
    date: date,
    summary: 'Tóm tắt',
  );
}

void main() {
  const vi = Locale('vi');
  const en = Locale('en');

  late GrowthProvider provider;
  late int notifications;

  GrowthNote byId(String id) => provider.notes.firstWhere((n) => n.id == id);
  bool has(String id) => provider.notes.any((n) => n.id == id);

  setUpAll(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  setUp(() async {
    await StorageService.instance.clearAll();

    provider = GrowthProvider(locale: vi);
    notifications = 0;
    provider.addListener(() => notifications++);
  });

  tearDown(() {
    provider.dispose();
  });

  test('starts with the sample notes of the locale', () {
    expect(provider.notes.map((n) => n.id),
        sampleNotesFor(vi).map((n) => n.id));
  });

  group('add', () {
    test('inserts by date, newest first, and notifies', () {
      provider.add(_note('newest', date: '01/01/2030'));
      provider.add(_note('oldest', date: '01/01/2000'));

      expect(provider.notes.first.id, 'newest');
      expect(provider.notes.last.id, 'oldest');
      expect(notifications, 2);
    });

    test('persists the note', () async {
      provider.add(_note('persisted'));
      await pumpEventQueue();

      final saved = await GrowthRepository().loadNotes();
      expect(saved!.map((n) => n.id), contains('persisted'));
    });
  });

  group('update', () {
    test('replaces the note and re-sorts it when the date changes', () {
      provider.add(_note('a', date: '01/01/2030'));
      provider.add(_note('b', date: '01/01/2029'));

      provider.update(_note('a', date: '01/01/2000', title: 'Đã sửa'));

      expect(byId('a').title, 'Đã sửa');
      expect(provider.notes.last.id, 'a');
      expect(provider.notes.where((n) => n.id == 'a').length, 1);
    });
  });

  group('remove', () {
    test('remove deletes one note', () {
      provider.add(_note('a'));
      provider.add(_note('b'));

      provider.remove('a');

      expect(has('a'), isFalse);
      expect(has('b'), isTrue);
    });

    test('removeByPlant deletes only that plant\'s notes', () {
      provider.add(_note('a', plantName: 'Cây A'));
      provider.add(_note('b', plantName: 'Cây B'));

      provider.removeByPlant('Cây A');

      expect(has('a'), isFalse);
      expect(has('b'), isTrue);
    });

    test('removeByPlant does nothing when the plant has no notes', () {
      provider.removeByPlant('Không có cây này');

      expect(notifications, 0);
    });
  });

  group('renamePlant', () {
    test('renames the plant on matching notes only', () {
      provider.add(_note('a', plantName: 'Cũ'));
      provider.add(_note('b', plantName: 'Khác'));

      provider.renamePlant('Cũ', 'Mới');

      expect(byId('a').plantName, 'Mới');
      expect(byId('b').plantName, 'Khác');
    });

    test('does nothing when no note matches', () {
      provider.renamePlant('Không có', 'Mới');

      expect(notifications, 0);
    });
  });

  group('updateLocale', () {
    test('does nothing for the same language', () {
      provider.updateLocale(const Locale('vi', 'VN'));

      expect(notifications, 0);
    });

    test('translates untouched sample notes and keeps user notes', () {
      provider.add(_note('mine', title: 'Ghi chú của tôi'));
      notifications = 0;

      provider.updateLocale(en);

      final enSamples = {for (final n in sampleNotesFor(en)) n.id: n};
      for (final entry in enSamples.entries) {
        expect(byId(entry.key).title, entry.value.title);
      }
      expect(byId('mine').title, 'Ghi chú của tôi');
      expect(notifications, 1);
    });
  });

  group('load', () {
    test('keeps the samples when nothing was saved', () async {
      await provider.load();

      expect(provider.notes.map((n) => n.id),
          sampleNotesFor(vi).map((n) => n.id));
      expect(notifications, 1);
    });

    test('replaces the samples with saved notes', () async {
      await GrowthRepository().saveNotes([_note('saved')]);

      await provider.load();

      expect(provider.notes.map((n) => n.id), ['saved']);
    });

    test('actions made while loading are applied after loading', () async {
      await GrowthRepository().saveNotes([_note('saved', date: '01/01/2020')]);

      final loading = provider.load();
      provider.add(_note('queued', date: '01/01/2030'));

      expect(has('queued'), isFalse);

      await loading;

      expect(provider.notes.map((n) => n.id), ['queued', 'saved']);
    });
  });
}
