import 'package:flutter/widgets.dart' show Locale;
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/services/storage_service.dart';
import 'package:greenlife_app/utils/date_utils.dart';

class CareRepository {
  CareRepository({StorageService? storage})
      : _storage = storage ?? StorageService.instance;

  final StorageService _storage;

  List<CareTask> initialTasks(Locale locale) => sampleTasksFor(locale);

  static List<CareTask> sortByDue(List<CareTask> tasks) {
    final indexed = [for (var i = 0; i < tasks.length; i++) (i, tasks[i])];

    indexed.sort((a, b) {
      final taskA = a.$2;
      final taskB = b.$2;

      if (taskA.isCompleted != taskB.isCompleted) {
        return taskA.isCompleted ? 1 : -1;
      }

      final dueA = taskA.dueAt;
      final dueB = taskB.dueAt;
      if (dueA != null && dueB != null) {
        final compared = dueA.compareTo(dueB);
        if (compared != 0) return compared;
      } else if (dueA != null) {
        return -1;
      } else if (dueB != null) {
        return 1;
      }

      return a.$1.compareTo(b.$1);
    });

    return [for (final entry in indexed) entry.$2];
  }

  Future<List<CareTask>?> loadTasks() => _storage.loadTasks();

  Future<void> saveTasks(List<CareTask> tasks) => _storage.saveTasks(tasks);

  List<CareTask> pending(List<CareTask> tasks) {
    return tasks.where((task) => !task.isCompleted).toList();
  }

  List<CareTask> tasksOfPlant(List<CareTask> tasks, String plantName) {
    return tasks.where((task) => task.plantName == plantName).toList();
  }

  List<CareTask> upcomingReminders(List<CareTask> tasks, {DateTime? now}) {
    final current = now ?? DateTime.now();
    return tasks.where((task) {
      final dueAt = task.dueAt;
      return !task.isCompleted && dueAt != null && dueAt.isAfter(current);
    }).toList();
  }

  CareTask copyWith(
    CareTask task, {
    String? plantName,
    String? dueDate,
    bool? isCompleted,
  }) {
    return CareTask(
      id: task.id,
      title: task.title,
      plantName: plantName ?? task.plantName,
      type: task.type,
      dueDate: dueDate ?? task.dueDate,
      isCompleted: isCompleted ?? task.isCompleted,
      dueAt: task.dueAt,
      recurrence: task.recurrence,
    );
  }

  CareTask? nextOccurrence(CareTask task, Locale locale) {
    final current = task.dueAt;
    if (current == null || task.recurrence == CareTaskRecurrence.none) {
      return null;
    }

    late DateTime nextDate;
    switch (task.recurrence) {
      case CareTaskRecurrence.none:
        return null;
      case CareTaskRecurrence.daily:
        nextDate = current.add(const Duration(days: 1));
        break;
      case CareTaskRecurrence.everyThreeDays:
        nextDate = current.add(const Duration(days: 3));
        break;
      case CareTaskRecurrence.weekly:
        nextDate = current.add(const Duration(days: 7));
        break;
      case CareTaskRecurrence.monthly:
        final year = current.month == 12 ? current.year + 1 : current.year;
        final month = current.month == 12 ? 1 : current.month + 1;
        final lastDay = DateTime(year, month + 1, 0).day;
        nextDate = DateTime(
          year, month, current.day > lastDay ? lastDay : current.day,
          current.hour, current.minute,
        );
        break;
    }

    final isEnglish = locale.languageCode == 'en';
    return CareTask(
      id: '${task.id}-next-${nextDate.millisecondsSinceEpoch}',
      title: task.title,
      plantName: task.plantName,
      type: task.type,
      dueAt: nextDate,
      dueDate: AppDateUtils.formatDueDate(nextDate, isEnglish: isEnglish),
      recurrence: task.recurrence,
    );
  }

  bool isUntouchedSample(CareTask task) {
    for (final locale in AppLocalizations.supportedLocales) {
      for (final sample in sampleTasksFor(locale)) {
        if (sample.id == task.id &&
            sample.title == task.title &&
            sample.plantName == task.plantName &&
            sample.type == task.type) {
          return true;
        }
      }
    }
    return false;
  }

  List<CareTask> localize(List<CareTask> source, Locale locale) {
    final isEnglish = locale.languageCode == 'en';
    final samples = {
      for (final task in sampleTasksFor(locale)) task.id: task,
    };

    CareTask relabel(CareTask task) {
      final dueAt = task.dueAt;
      return dueAt == null
          ? task
          : copyWith(
              task,
              dueDate: AppDateUtils.formatDueDate(dueAt, isEnglish: isEnglish),
            );
    }

    return [
      for (final task in source)
        if (samples.containsKey(task.id) && isUntouchedSample(task))
          relabel(CareTask(
            id: task.id,
            title: samples[task.id]!.title,
            plantName: samples[task.id]!.plantName,
            type: task.type,
            dueDate: task.dueDate,
            isCompleted: task.isCompleted,
            dueAt: task.dueAt,
            recurrence: task.recurrence,
          ))
        else
          relabel(task),
    ];
  }
}