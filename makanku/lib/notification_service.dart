import 'dart:io'; // ✅ Untuk cek platform
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart'; // ✅ Untuk cek versi Android

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const String _prefKey = 'daily_reminder_enabled';
  static const int _notificationId = 0;

  /// Fungsi untuk inisialisasi notifikasi
  Future<void> init() async {
    // Initialize timezone package
    tz.initializeTimeZones();
    // Set local timezone based on device timezone (important for Android scheduling)
    try {
      final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
      if (timeZoneName != null && timeZoneName.isNotEmpty) {
        tz.setLocalLocation(tz.getLocation(timeZoneName));
      }
    } catch (e) {
      // ignore and fallback to default tz.local
    }


    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // ✅ Minta izin notifikasi ketika inisialisasi pertama kali
    await requestNotificationPermission();

    // Cek preferensi pengguna (aktif/nonaktif)
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_prefKey) ?? true;
    if (enabled) {
      await scheduleDailyLunchNotification(hour: 11, minute: 0);
    } else {
      await cancelDailyNotification();
    }
  }

  Future<void> setDailyReminderEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, enabled);
    if (enabled) {
      await scheduleDailyLunchNotification(hour: 11, minute: 0);
    } else {
      await cancelDailyNotification();
    }
  }

  Future<bool> isDailyReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? true;
  }

  Future<void> scheduleDailyLunchNotification({int hour = 11, int minute = 0}) async {
    // Batalkan notifikasi sebelumnya untuk menghindari duplikasi
    await cancelDailyNotification();

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'daily_lunch_channel',
      'Daily Lunch Reminder',
      channelDescription: 'Channel for daily lunch reminder at 11:00',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      _notificationId,
      'Sudah jam makan siang! Yuk, istirahat dulu 🍱',
      'Ingat untuk makan dan istirahat sejenak.',
      scheduledDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // ulangi setiap hari pada waktu yang sama
      payload: 'daily_lunch',
    );
  }

  Future<void> cancelDailyNotification() async {
    await flutterLocalNotificationsPlugin.cancel(_notificationId);
  }
}

/// ✅ Fungsi di luar class untuk meminta izin notifikasi khusus Android 13+
/// Bisa dipanggil di main.dart sebelum inisialisasi NotificationService
Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final androidVersion = androidInfo.version.sdkInt;

    // ✅ Izin notifikasi untuk Android 13+
    if (androidVersion >= 33) { // Android 13+
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }
    }

    // ✅ Izin exact alarm scheduling untuk Android 12+
    if (androidVersion >= 31) { // Android 12+
      try {
        if (await Permission.scheduleExactAlarm.isDenied) {
          await Permission.scheduleExactAlarm.request();
        }
      } catch (_) {
        // permission_handler mungkin tidak support di beberapa platform
      }
    }
  }
}