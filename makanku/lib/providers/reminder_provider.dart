import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/notification_helper.dart';

class ReminderProvider extends ChangeNotifier {
  static const _reminderKey = 'daily_reminder_enabled';
  bool _reminderEnabled = false;
  bool _isLoading = true;

  bool get reminderEnabled => _reminderEnabled;
  bool get isLoading => _isLoading;

  ReminderProvider() {
    _init();
  }

  Future<void> _init() async {
    NotificationHelper.initialize();
    await _loadPreference();
  }

  Future<void> _loadPreference() async {
    final sp = await SharedPreferences.getInstance();
    _reminderEnabled = sp.getBool(_reminderKey) ?? false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleReminder(BuildContext context, bool value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_reminderKey, value);
    _reminderEnabled = value;
    notifyListeners();

    if (value) {
      await NotificationHelper.scheduleDailyNotification(
        id: 0,
        hour: 11,
        minute: 0,
        title: 'Lunch time',
        body: "Don't forget to have your lunch!",
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Alarm aktif! Pengingat akan muncul setiap hari jam 11:00 AM'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      await NotificationHelper.cancel(0);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Alarm dinonaktifkan'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}
