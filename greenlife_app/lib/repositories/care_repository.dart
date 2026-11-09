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
    );
  }

  bool isUntouchedSample(CareTask task) {
    for (final locale in AppLocalizations.supportedLocales) {
      for (final sample in sampleTasksFor(locale)) {
        if (sample.id == task.id &&
            sample.title == task.title &&
            sample.plantName == task.plantName &&
            sample.type == task.type &&
            sample.dueDate == task.dueDate) {
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

    return [
      for (final task in source)
        if (samples.containsKey(task.id) && isUntouchedSample(task))
          copyWith(samples[task.id]!, isCompleted: task.isCompleted)
        else if (task.dueAt != null)
          copyWith(
            task,
            dueDate: AppDateUtils.formatDueDate(
              task.dueAt!,
              isEnglish: isEnglish,
            ),
          )
        else
          task,
    ];
  }
}