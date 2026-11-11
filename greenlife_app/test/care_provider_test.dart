import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/providers/care_provider.dart';
import 'package:greenlife_app/repositories/care_repository.dart';
import 'package:greenlife_app/services/storage_service.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

CareTask _task(
  String id, {
  String plantName = 'Cây thử',
  DateTime? dueAt,
  bool isCompleted = false,
  CareTaskRecurrence recurrence = CareTaskRecurrence.none,
}) {
  return CareTask(
    id: id,
    title: 'Task $id',
    plantName: plantName,
    type: 'watering',
    dueDate: '',
    isCompleted: isCompleted,
    dueAt: dueAt,
    recurrence: recurrence,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const vi = Locale('vi');
  const en = Locale('en');

  late CareProvider provider;
  late int notifications;

  CareTask byId(String id) => provider.tasks.firstWhere((t) => t.id == id);
  bool has(String id) => provider.tasks.any((t) => t.id == id);

  setUpAll(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  setUp(() async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    await StorageService.instance.clearAll();

    provider = CareProvider(locale: vi);
    notifications = 0;
    provider.addListener(() => notifications++);
  });

  tearDown(() {
    provider.dispose();
    debugDefaultTargetPlatformOverride = null;
  });

  test('starts with the sample tasks of the locale', () {
    expect(provider.tasks.map((t) => t.id),
        sampleTasksFor(vi).map((t) => t.id));
  });

  group('add', () {
    test('inserts the task at the top and notifies listeners', () {
      provider.add(_task('new'));

      expect(provider.tasks.first.id, 'new');
      expect(notifications, 1);
    });

    test('persists the new task', () async {
      provider.add(_task('persisted'));
      await pumpEventQueue();

      final saved = await CareRepository().loadTasks();
      expect(saved!.map((t) => t.id), contains('persisted'));
    });
  });

  group('toggle', () {
    test('flips the completion state both ways', () {
      provider.add(_task('t'));

      provider.toggle('t');
      expect(byId('t').isCompleted, isTrue);

      provider.toggle('t');
      expect(byId('t').isCompleted, isFalse);
    });

    test('ignores unknown ids without notifying', () {
      provider.toggle('missing');

      expect(notifications, 0);
    });

    test('does not create a follow-up task without recurrence', () {
      provider.add(_task('once', dueAt: DateTime(2099, 1, 1, 8)));
      final before = provider.tasks.length;

      provider.toggle('once');

      expect(provider.tasks.length, before);
    });

    test('completing a recurring task creates the next occurrence', () {
      final dueAt = DateTime(2099, 1, 10, 8);
      provider.add(_task(
        'daily',
        dueAt: dueAt,
        recurrence: CareTaskRecurrence.daily,
      ));
      final before = provider.tasks.length;

      provider.toggle('daily');

      expect(provider.tasks.length, before + 1);
      final next = provider.tasks.first;
      expect(next.id, startsWith('daily-next-'));
      expect(next.dueAt, DateTime(2099, 1, 11, 8));
      expect(next.isCompleted, isFalse);
    });

    test('completing the same task again does not duplicate the next one', () {
      provider.add(_task(
        'weekly',
        dueAt: DateTime(2099, 1, 10, 8),
        recurrence: CareTaskRecurrence.weekly,
      ));

      provider.toggle('weekly'); // complete -> creates next
      provider.toggle('weekly'); // reopen
      provider.toggle('weekly'); // complete again -> same next id

      final nextTasks =
          provider.tasks.where((t) => t.id.startsWith('weekly-next-'));
      expect(nextTasks.length, 1);
    });
  });

  group('update', () {
    test('replaces the task with the same id', () {
      provider.add(_task('t'));

      provider.update(CareTask(
        id: 't',
        title: 'Đã sửa',
        plantName: 'Cây thử',
        type: 'prune',
        dueDate: '',
      ));

      expect(byId('t').title, 'Đã sửa');
      expect(byId('t').type, 'prune');
    });

    test('ignores unknown ids without notifying', () {
      provider.update(_task('missing'));

      expect(has('missing'), isFalse);
      expect(notifications, 0);
    });
  });

  group('remove', () {
    test('remove deletes one task', () {
      provider.add(_task('a'));
      provider.add(_task('b'));

      provider.remove('a');

      expect(has('a'), isFalse);
      expect(has('b'), isTrue);
    });

    test('removeByPlant deletes all tasks of that plant only', () {
      provider.add(_task('a', plantName: 'Cây A'));
      provider.add(_task('b', plantName: 'Cây A'));
      provider.add(_task('c', plantName: 'Cây B'));

      provider.removeByPlant('Cây A');

      expect(has('a'), isFalse);
      expect(has('b'), isFalse);
      expect(has('c'), isTrue);
    });

    test('removeByPlant does nothing when the plant has no tasks', () {
      provider.removeByPlant('Không có cây này');

      expect(notifications, 0);
    });
  });

  group('renamePlant', () {
    test('renames the plant on matching tasks only', () {
      provider.add(_task('a', plantName: 'Cũ'));
      provider.add(_task('b', plantName: 'Khác'));

      provider.renamePlant('Cũ', 'Mới');

      expect(byId('a').plantName, 'Mới');
      expect(byId('b').plantName, 'Khác');
    });

    test('does nothing when no task matches', () {
      provider.renamePlant('Không có', 'Mới');

      expect(notifications, 0);
    });
  });

  group('updateLocale', () {
    test('does nothing for the same language', () {
      provider.updateLocale(const Locale('vi', 'VN'));

      expect(notifications, 0);
    });

    test('translates sample task titles and plant names', () {
      provider.updateLocale(en);

      final enSamples = sampleTasksFor(en);
      for (final sample in enSamples) {
        expect(byId(sample.id).title, sample.title);
        expect(byId(sample.id).plantName, sample.plantName);
      }
    });

    test('relabels due dates when the language changes', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      provider.add(_task('t', dueAt: tomorrow));
      notifications = 0;

      provider.updateLocale(en);

      expect(byId('t').dueDate, startsWith('Tomorrow'));
      expect(notifications, 1);

      provider.updateLocale(vi);
      expect(byId('t').dueDate, startsWith('Ngày mai'));
    });
  });

  group('refreshLabels', () {
    test('does not notify when no label changed', () {
      provider.refreshLabels();

      expect(notifications, 0);
    });

    test('updates stale labels and notifies', () {
      provider.add(_task('stale', dueAt: DateTime.now()));
      notifications = 0;

      provider.refreshLabels();

      expect(byId('stale').dueDate, startsWith('Hôm nay'));
      expect(notifications, 1);
    });
  });

  group('load', () {
    test('keeps the samples when nothing was saved', () async {
      await provider.load();

      expect(provider.tasks.map((t) => t.id),
          sampleTasksFor(vi).map((t) => t.id));
      expect(notifications, 1);
    });

    test('replaces the samples with saved tasks', () async {
      await CareRepository().saveTasks([_task('saved')]);

      await provider.load();

      expect(provider.tasks.map((t) => t.id), ['saved']);
    });

    test('actions made while loading are applied after loading', () async {
      await CareRepository().saveTasks([_task('saved')]);

      final loading = provider.load();
      provider.add(_task('queued'));

      expect(has('queued'), isFalse);

      await loading;

      expect(provider.tasks.map((t) => t.id), ['queued', 'saved']);
    });
  });
}
