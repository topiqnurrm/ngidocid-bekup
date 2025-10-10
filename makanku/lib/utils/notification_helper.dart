import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;

class NotificationHelper {
  static final _plugin = FlutterLocalNotificationsPlugin();

  /// Inisialisasi notifikasi lokal
  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings);
    tzdata.initializeTimeZones();

    // Request runtime notification permission on Android 13+ (POST_NOTIFICATIONS)
    if (Platform.isAndroid) {
      await requestNotificationPermission();
    }
  }

  /// Request permissions (POST_NOTIFICATIONS for Android 13+, and schedule exact alarm)
  static Future<void> requestNotificationPermission() async {
    try {
      // POST_NOTIFICATIONS (Android 13+)
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }

      // SCHEDULE_EXACT_ALARM (requires special handling starting Android 12+)
      // permission_handler exposes scheduleExactAlarm on supported platforms
      if (Platform.isAndroid) {
        if (await Permission.scheduleExactAlarm.isDenied) {
          await Permission.scheduleExactAlarm.request();
        }
      }
    } catch (_) {
      // ignore any permission handler exceptions; best-effort
    }
  }

static Future<void> scheduleDailyNotification({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Jika waktu sudah lewat hari ini → jadwalkan untuk besok
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Reminder',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Membatalkan notifikasi berdasarkan [id]
  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}
