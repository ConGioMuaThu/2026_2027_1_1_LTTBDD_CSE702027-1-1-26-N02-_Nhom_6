import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/repositories/care_repository.dart';
import 'package:greenlife_app/services/storage_service.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

CareTask _task(
  String id, {
  String plantName = 'Trầu bà',
  String type = 'watering',
  DateTime? dueAt,
  bool isCompleted = false,
  CareTaskRecurrence recurrence = CareTaskRecurrence.none,
  String dueDate = '',
}) {
  return CareTask(
    id: id,
    title: 'Task $id',
    plantName: plantName,
    type: type,
    dueDate: dueDate,
    isCompleted: isCompleted,
    dueAt: dueAt,
    recurrence: recurrence,
  );
}

void main() {
  const vi = Locale('vi');
  const en = Locale('en');
  final repository = CareRepository();

  setUpAll(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  setUp(() async {
    await StorageService.instance.clearAll();
  });

  group('sortByDue', () {
    test('puts incomplete tasks before completed ones', () {
      final sorted = CareRepository.sortByDue([
        _task('done', isCompleted: true, dueAt: DateTime(2099, 1, 1)),
        _task('open', dueAt: DateTime(2099, 6, 1)),
      ]);

      expect(sorted.map((t) => t.id), ['open', 'done']);
    });

    test('orders by due time within the same completion state', () {
      final sorted = CareRepository.sortByDue([
        _task('c', dueAt: DateTime(2099, 3, 1)),
        _task('a', dueAt: DateTime(2099, 1, 1)),
        _task('b', dueAt: DateTime(2099, 2, 1)),
      ]);

      expect(sorted.map((t) => t.id), ['a', 'b', 'c']);
    });

    test('places tasks without a due time after dated ones', () {
      final sorted = CareRepository.sortByDue([
        _task('none'),
        _task('dated', dueAt: DateTime(2099, 1, 1)),
      ]);

      expect(sorted.map((t) => t.id), ['dated', 'none']);
    });

    test('is stable for equal due times and for undated tasks', () {
      final same = DateTime(2099, 1, 1, 8);
      final sorted = CareRepository.sortByDue([
        _task('x1', dueAt: same),
        _task('x2', dueAt: same),
        _task('y1'),
        _task('y2'),
      ]);

      expect(sorted.map((t) => t.id), ['x1', 'x2', 'y1', 'y2']);
    });

    test('does not modify the input list', () {
      final input = [
        _task('b', dueAt: DateTime(2099, 2, 1)),
        _task('a', dueAt: DateTime(2099, 1, 1)),
      ];

      CareRepository.sortByDue(input);

      expect(input.map((t) => t.id), ['b', 'a']);
    });

    test('handles an empty list', () {
      expect(CareRepository.sortByDue(const []), isEmpty);
    });
  });

  group('filters', () {
    final tasks = [
      _task('1', plantName: 'Trầu bà'),
      _task('2', plantName: 'Sen đá', isCompleted: true),
      _task('3', plantName: 'Trầu bà', isCompleted: true),
    ];

    test('pending keeps only incomplete tasks', () {
      expect(repository.pending(tasks).map((t) => t.id), ['1']);
    });

    test('tasksOfPlant matches the exact plant name', () {
      expect(repository.tasksOfPlant(tasks, 'Trầu bà').map((t) => t.id),
          ['1', '3']);
      expect(repository.tasksOfPlant(tasks, 'Trầu'), isEmpty);
    });

    test('upcomingReminders keeps future, incomplete, dated tasks', () {
      final now = DateTime(2026, 11, 11, 12);
      final upcoming = repository.upcomingReminders([
        _task('past', dueAt: DateTime(2026, 11, 11, 11)),
        _task('future', dueAt: DateTime(2026, 11, 11, 13)),
        _task('done', dueAt: DateTime(2026, 11, 12), isCompleted: true),
        _task('undated'),
        _task('exactly-now', dueAt: now),
      ], now: now);

      expect(upcoming.map((t) => t.id), ['future']);
    });
  });

  group('copyWith', () {
    test('overrides only the requested fields', () {
      final original = _task(
        'a',
        dueAt: DateTime(2099, 1, 1),
        recurrence: CareTaskRecurrence.weekly,
        dueDate: 'old',
      );

      final copy = repository.copyWith(
        original,
        plantName: 'Sen đá',
        dueDate: 'new',
        isCompleted: true,
      );

      expect(copy.plantName, 'Sen đá');
      expect(copy.dueDate, 'new');
      expect(copy.isCompleted, isTrue);
      expect(copy.id, original.id);
      expect(copy.title, original.title);
      expect(copy.type, original.type);
      expect(copy.dueAt, original.dueAt);
      expect(copy.recurrence, CareTaskRecurrence.weekly);
    });

    test('keeps every field when nothing is overridden', () {
      final original = _task('a', isCompleted: true, dueDate: 'x');

      final copy = repository.copyWith(original);

      expect(copy.plantName, original.plantName);
      expect(copy.dueDate, 'x');
      expect(copy.isCompleted, isTrue);
    });
  });

  group('nextOccurrence', () {
    CareTask? next(
      CareTaskRecurrence recurrence,
      DateTime dueAt, {
      Locale locale = vi,
    }) {
      return repository.nextOccurrence(
        _task('t', dueAt: dueAt, recurrence: recurrence),
        locale,
      );
    }

    test('returns null without recurrence or without a due time', () {
      expect(next(CareTaskRecurrence.none, DateTime(2099, 1, 1)), isNull);
      expect(
        repository.nextOccurrence(
          _task('t', recurrence: CareTaskRecurrence.daily),
          vi,
        ),
        isNull,
      );
    });

    test('daily, every three days and weekly add fixed day counts', () {
      final base = DateTime(2099, 1, 10, 8, 30);

      expect(next(CareTaskRecurrence.daily, base)!.dueAt,
          DateTime(2099, 1, 11, 8, 30));
      expect(next(CareTaskRecurrence.everyThreeDays, base)!.dueAt,
          DateTime(2099, 1, 13, 8, 30));
      expect(next(CareTaskRecurrence.weekly, base)!.dueAt,
          DateTime(2099, 1, 17, 8, 30));
    });

    test('monthly keeps the day and time when possible', () {
      expect(next(CareTaskRecurrence.monthly, DateTime(2099, 3, 15, 7, 45))!.dueAt,
          DateTime(2099, 4, 15, 7, 45));
    });

    test('monthly clamps to the last day of a shorter month', () {
      expect(next(CareTaskRecurrence.monthly, DateTime(2099, 1, 31, 8))!.dueAt,
          DateTime(2099, 2, 28, 8));
      expect(next(CareTaskRecurrence.monthly, DateTime(2099, 3, 31, 8))!.dueAt,
          DateTime(2099, 4, 30, 8));
      // 2096 is a leap year.
      expect(next(CareTaskRecurrence.monthly, DateTime(2096, 1, 31, 8))!.dueAt,
          DateTime(2096, 2, 29, 8));
    });

    test('monthly rolls over from December to January of the next year', () {
      expect(next(CareTaskRecurrence.monthly, DateTime(2098, 12, 20, 9))!.dueAt,
          DateTime(2099, 1, 20, 9));
    });

    test('the next task keeps its data and gets a derived id', () {
      final dueAt = DateTime(2099, 1, 10, 8);
      final original = _task(
        'water-1',
        plantName: 'Sen đá',
        type: 'watering',
        dueAt: dueAt,
        isCompleted: true,
        recurrence: CareTaskRecurrence.daily,
      );

      final created = repository.nextOccurrence(original, vi)!;

      expect(created.id,
          'water-1-next-${DateTime(2099, 1, 11, 8).millisecondsSinceEpoch}');
      expect(created.title, original.title);
      expect(created.plantName, 'Sen đá');
      expect(created.type, 'watering');
      expect(created.recurrence, CareTaskRecurrence.daily);
      expect(created.isCompleted, isFalse);
      expect(created.dueDate, '11/01/2099, 08:00');
    });

    test('is deterministic, so the same completion yields the same id', () {
      final dueAt = DateTime(2099, 1, 10, 8);

      expect(next(CareTaskRecurrence.weekly, dueAt)!.id,
          next(CareTaskRecurrence.weekly, dueAt)!.id);
    });
  });

  group('localize', () {
    test('rebuilds the due label of dated tasks in the new language', () {
      final dueAt = DateTime.now().add(const Duration(days: 1));
      final task = _task('t', dueAt: dueAt, dueDate: 'stale');

      final inVi = repository.localize([task], vi).single;
      final inEn = repository.localize([task], en).single;

      expect(inVi.dueDate, startsWith('Ngày mai'));
      expect(inEn.dueDate, startsWith('Tomorrow'));
      expect(inVi.title, task.title);
    });

    test('leaves tasks without a due time untouched', () {
      final task = _task('plain', dueDate: 'keep me');

      expect(repository.localize([task], en).single, same(task));
    });

    test('translates untouched sample tasks and keeps their schedule state', () {
      final viSamples = sampleTasksFor(vi);
      final enSamples = sampleTasksFor(en);
      final done = repository.copyWith(viSamples.first, isCompleted: true);

      final localized = repository.localize([done, ...viSamples.skip(1)], en);

      for (var i = 0; i < viSamples.length; i++) {
        expect(localized[i].title, enSamples[i].title, reason: 'task $i');
        expect(localized[i].plantName, enSamples[i].plantName);
      }
      expect(localized.first.isCompleted, isTrue);
      expect(localized.first.dueAt, viSamples.first.dueAt);
    });

    test('a sample the user renamed is not translated', () {
      final sample = sampleTasksFor(vi).first;
      final edited = CareTask(
        id: sample.id,
        title: 'Việc của tôi',
        plantName: sample.plantName,
        type: sample.type,
        dueDate: sample.dueDate,
        dueAt: sample.dueAt,
      );

      expect(repository.localize([edited], en).single.title, 'Việc của tôi');
    });

    test('a rescheduled sample still translates but keeps its new time', () {
      final sample = sampleTasksFor(vi).first;
      final moved = CareTask(
        id: sample.id,
        title: sample.title,
        plantName: sample.plantName,
        type: sample.type,
        dueDate: '',
        dueAt: DateTime(2099, 5, 5, 6, 0),
      );

      final result = repository.localize([moved], en).single;

      expect(result.title, sampleTasksFor(en).first.title);
      expect(result.dueAt, DateTime(2099, 5, 5, 6, 0));
      expect(result.dueDate, '05/05/2099, 06:00');
    });

    test('preserves the order and length of the input', () {
      final tasks = [
        _task('a', dueAt: DateTime(2099, 1, 1)),
        _task('b'),
        _task('c', dueAt: DateTime(2099, 1, 2)),
      ];

      expect(repository.localize(tasks, vi).map((t) => t.id), ['a', 'b', 'c']);
    });
  });

  group('initialTasks and persistence', () {
    test('initialTasks returns the sample tasks for the locale', () {
      expect(repository.initialTasks(vi).map((t) => t.id),
          sampleTasksFor(vi).map((t) => t.id));
      expect(repository.initialTasks(en).first.title,
          sampleTasksFor(en).first.title);
    });

    test('saveTasks then loadTasks returns the saved tasks', () async {
      expect(await repository.loadTasks(), isNull);

      await repository.saveTasks([_task('saved', dueAt: DateTime(2099, 1, 1))]);

      final loaded = await repository.loadTasks();
      expect(loaded!.map((t) => t.id), ['saved']);
      expect(loaded.single.dueAt, DateTime(2099, 1, 1));
    });
  });
}
