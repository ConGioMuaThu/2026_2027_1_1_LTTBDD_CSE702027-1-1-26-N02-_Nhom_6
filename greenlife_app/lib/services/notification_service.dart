import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String _channelId = 'care_reminders';
  static const String _channelName = 'Care reminders';
  static const String _channelDescription = 'Reminders for plant care tasks';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  bool get isSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  Future<void> init() async {
    if (_initialized || !isSupported) return;

    try {
      tz_data.initializeTimeZones();

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      await _plugin.initialize(
        settings: const InitializationSettings(
          android: androidSettings,
          iOS: darwinSettings,
          macOS: darwinSettings,
        ),
      );

      _initialized = true;
    } catch (_) {
      _initialized = false;
    }
  }

  Future<bool> requestPermission() async {
    if (!isSupported) return false;
    await init();
    if (!_initialized) return false;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final granted = await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
        return granted ?? false;
      case TargetPlatform.iOS:
        final granted = await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        return granted ?? false;
      case TargetPlatform.macOS:
        final granted = await _plugin
            .resolvePlatformSpecificImplementation<
                MacOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        return granted ?? false;
      default:
        return false;
    }
  }

  Future<bool> scheduleTaskReminder({
    required String taskId,
    required String title,
    required String body,
    required DateTime scheduledAt,
  }) async {
    if (!isSupported) return false;
    await init();
    if (!_initialized) return false;

    if (!scheduledAt.isAfter(DateTime.now())) return false;

    try {
      await _plugin.zonedSchedule(
        id: _notificationId(taskId),
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledAt, tz.UTC),
        notificationDetails: _details(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: taskId,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> showNow({
    required String title,
    required String body,
  }) async {
    if (!isSupported) return;
    await init();
    if (!_initialized) return;

    try {
      await _plugin.show(
        id: _notificationId('now-${DateTime.now().millisecondsSinceEpoch}'),
        title: title,
        body: body,
        notificationDetails: _details(),
      );
    } catch (_) {
      return;
    }
  }

  Future<void> cancelTaskReminder(String taskId) async {
    if (!isSupported) return;
    await init();
    if (!_initialized) return;
    await _plugin.cancel(id: _notificationId(taskId));
  }

  Future<void> cancelAll() async {
    if (!isSupported) return;
    await init();
    if (!_initialized) return;
    await _plugin.cancelAll();
  }

  NotificationDetails _details() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );
  }

  int _notificationId(String key) {
    var hash = 7;
    for (final unit in key.codeUnits) {
      hash = (hash * 31 + unit) & 0x7FFFFFFF;
    }
    return hash;
  }
}