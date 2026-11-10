import 'dart:collection';
import 'package:flutter/widgets.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/repositories/care_repository.dart';
import 'package:greenlife_app/services/notification_service.dart';

class CareProvider extends ChangeNotifier {
  CareProvider({
    required Locale locale,
    CareRepository? repository,
    NotificationService? notifications,
  })  : _locale = locale,
        _repository = repository ?? CareRepository(),
        _notifications = notifications ?? NotificationService.instance {
    _tasks = _repository.initialTasks(locale);
  }

  final CareRepository _repository;
  final NotificationService _notifications;
  final List<VoidCallback> _pending = [];

  Locale _locale;
  late List<CareTask> _tasks;
  bool _loading = false;
  bool _disposed = false;

  UnmodifiableListView<CareTask> get tasks => UnmodifiableListView(_tasks);

  Future<void> load() async {
    _loading = true;
    var restored = false;

    try {
      final saved = await _repository.loadTasks();
      if (_disposed) return;
      if (saved != null) {
        _tasks = _repository.localize(saved, _locale);
        restored = true;
      }
    } finally {
      _loading = false;
      if (!_disposed) _flushPending();
    }

    if (_disposed) return;
    notifyListeners();
  }

  void updateLocale(Locale locale) {
    if (locale.languageCode == _locale.languageCode) return;

    _locale = locale;
    _tasks = _repository.localize(_tasks, locale);
    if (!_loading) _persist();
    notifyListeners();
  }

  void refreshLabels() {
    final refreshed = _repository.localize(_tasks, _locale);

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

      final updated = _repository.copyWith(
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

  void update(CareTask task) {
    _run(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index == -1) return;

      _tasks[index] = task;
      _persist();
      notifyListeners();

      _notifications.cancelTaskReminder(task.id);
      _scheduleReminder(task);
    });
  }

  void removeByPlant(String plantName) {
    _run(() {
      final removed = _tasks.where((t) => t.plantName == plantName).toList();
      if (removed.isEmpty) return;

      _tasks.removeWhere((t) => t.plantName == plantName);
      _persist();
      notifyListeners();

      for (final task in removed) {
        _notifications.cancelTaskReminder(task.id);
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
    _repository.saveTasks(_tasks);
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

    final upcoming = _repository.upcomingReminders(_tasks);
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
    final renamed = _repository.copyWith(task, plantName: name);
    sink.add(renamed);
    return renamed;
  }

  @override
  void dispose() {
    _disposed = true;
    _pending.clear();
    super.dispose();
  }
}