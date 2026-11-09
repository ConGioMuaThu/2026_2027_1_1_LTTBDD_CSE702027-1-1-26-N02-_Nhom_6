import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/services/notification_service.dart';
import 'package:greenlife_app/services/storage_service.dart';
import 'package:greenlife_app/utils/date_utils.dart';

class CareProvider extends ChangeNotifier {
  CareProvider({
    required Locale locale,
    StorageService? storage,
    NotificationService? notifications,
  })  : _locale = locale,
        _storage = storage ?? StorageService.instance,
        _notifications = notifications ?? NotificationService.instance,
        _tasks = sampleTasksFor(locale);

  final StorageService _storage;
  final NotificationService _notifications;
  final List<VoidCallback> _pending = [];

  Locale _locale;
  List<CareTask> _tasks;
  bool _loading = false;
  bool _disposed = false;

  UnmodifiableListView<CareTask> get tasks => UnmodifiableListView(_tasks);

  Future<void> load() async {
    _loading = true;
    var restored = false;

    try {
      final saved = await _storage.loadTasks();
      if (_disposed) return;
      if (saved != null) {
        _tasks = _refreshed(saved, _locale);
        restored = true;
      }
    } finally {
      _loading = false;
      if (!_disposed) _flushPending();
    }

    if (_disposed) return;
    notifyListeners();
    if (restored) await _rescheduleAll();
  }

  void updateLocale(Locale locale) {
    if (locale.languageCode == _locale.languageCode) return;

    _locale = locale;
    _tasks = _refreshed(_tasks, locale);
    if (!_loading) _persist();
    notifyListeners();
  }

  void refreshLabels() {
    final refreshed = _refreshed(_tasks, _locale);

    var changed = false;
    for (var i = 0; i < refreshed.length; i++) {
      if (refreshed[i].dueDate != _tasks[i].dueDate) {
        changed = true;
        break;
      }
    }
    if (!changed) return;

    _tasks = refreshed;
    notifyListeners();
  }

  void toggle(String id) {
    _run(() {
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index == -1) return;

      final updated = _copyWith(
        _tasks[index],
        isCompleted: !_tasks[index].isCompleted,
      );
      _tasks[index] = updated;
      _persist();
      notifyListeners();

      if (updated.isCompleted) {
        _notifications.cancelTaskReminder(updated.id);
      } else {
        _scheduleReminder(updated);
      }
    });
  }

  void add(CareTask task) {
    _run(() {
      _tasks.insert(0, task);
      _persist();
      notifyListeners();
      _scheduleReminder(task);
    });
  }

  void renamePlant(String oldName, String newName) {
    _run(() {
      final renamed = <CareTask>[];
      final updated = [
        for (final task in _tasks)
          if (task.plantName == oldName)
            _withPlantName(task, newName, renamed)
          else
            task,
      ];
      if (renamed.isEmpty) return;

      _tasks = updated;
      _persist();
      notifyListeners();

      for (final task in renamed) {
        _scheduleReminder(task);
      }
    });
  }

  void remove(String id) {
    _run(() {
      _tasks.removeWhere((t) => t.id == id);
      _persist();
      notifyListeners();
      _notifications.cancelTaskReminder(id);
    });
  }

  void _run(VoidCallback action) {
    if (_loading) {
      _pending.add(action);
    } else {
      action();
    }
  }

  void _flushPending() {
    final queued = List<VoidCallback>.of(_pending);
    _pending.clear();
    for (final action in queued) {
      action();
    }
  }

  void _persist() {
    _storage.saveTasks(_tasks);
  }

  Future<void> _scheduleReminder(CareTask task) async {
    final dueAt = task.dueAt;
    if (dueAt == null || task.isCompleted) return;
    if (!_notifications.isSupported) return;

    await _notifications.requestPermission();
    await _notifications.scheduleTaskReminder(
      taskId: task.id,
      title: task.title,
      body: task.plantName,
      scheduledAt: dueAt,
    );
  }

  Future<void> _rescheduleAll() async {
    if (!_notifications.isSupported) return;

    final now = DateTime.now();
    final upcoming = _tasks.where((task) {
      final dueAt = task.dueAt;
      return !task.isCompleted && dueAt != null && dueAt.isAfter(now);
    }).toList();
    if (upcoming.isEmpty) return;

    final granted = await _notifications.requestPermission();
    if (!granted) return;

    for (final task in upcoming) {
      await _notifications.scheduleTaskReminder(
        taskId: task.id,
        title: task.title,
        body: task.plantName,
        scheduledAt: task.dueAt!,
      );
    }
  }

  CareTask _withPlantName(CareTask task, String name, List<CareTask> sink) {
    final renamed = CareTask(
      id: task.id,
      title: task.title,
      plantName: name,
      type: task.type,
      dueDate: task.dueDate,
      isCompleted: task.isCompleted,
      dueAt: task.dueAt,
    );
    sink.add(renamed);
    return renamed;
  }

  bool _isUntouchedSample(CareTask task) {
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

  List<CareTask> _refreshed(List<CareTask> source, Locale locale) {
    final isEnglish = locale.languageCode == 'en';
    final samples = {
      for (final task in sampleTasksFor(locale)) task.id: task,
    };

    return [
      for (final task in source)
        if (samples.containsKey(task.id) && _isUntouchedSample(task))
          _copyWith(samples[task.id]!, isCompleted: task.isCompleted)
        else if (task.dueAt != null)
          _copyWith(
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

  CareTask _copyWith(CareTask task, {bool? isCompleted, String? dueDate}) {
    return CareTask(
      id: task.id,
      title: task.title,
      plantName: task.plantName,
      type: task.type,
      dueDate: dueDate ?? task.dueDate,
      isCompleted: isCompleted ?? task.isCompleted,
      dueAt: task.dueAt,
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _pending.clear();
    super.dispose();
  }
}