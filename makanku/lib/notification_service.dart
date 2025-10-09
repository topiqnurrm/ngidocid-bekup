import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _prefKey = 'daily_reminder_enabled';
  static const int _notificationId = 0;

  Future<void> init() async {
    // initialize timezone package
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // If enabled by preference and not scheduled, schedule on init
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
    // Cancel existing first (to avoid duplicates)
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

    // Note: recent versions of flutter_local_notifications require specifying
    // `androidScheduleMode`. Choose `exactAllowWhileIdle` to try and show at the exact time
    // even while idle. If you prefer not to request exact-alarm permissions you can use
    // `inexact` or `inexactAllowWhileIdle` instead.
    await flutterLocalNotificationsPlugin.zonedSchedule(
      _notificationId,
      'Sudah jam makan siang! Yuk, istirahat dulu 🍱',
      'Ingat untuk makan dan istirahat sejenak.',
      scheduledDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // This makes it repeat daily at the same time.
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_lunch',
    );
  }

  Future<void> cancelDailyNotification() async {
    await flutterLocalNotificationsPlugin.cancel(_notificationId);
  }
}
