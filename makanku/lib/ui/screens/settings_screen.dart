import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/notification_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _reminder = false;
  static const _reminderKey = 'daily_reminder_enabled';

  @override
  void initState() {
    super.initState();
    _loadPref();
    NotificationHelper.initialize();
  }

  Future<void> _loadPref() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _reminder = sp.getBool(_reminderKey) ?? false;
    });
  }

  Future<void> _toggleReminder(bool v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_reminderKey, v);
    setState(() {
      _reminder = v;
    });
    if (v) {
      await NotificationHelper.scheduleDailyNotification(
          id: 0,
          hour: 11,
          minute: 0,
          title: 'Lunch time',
          body: 'Don\'t forget to have your lunch!'
      );

      // Tampilkan SnackBar saat alarm diaktifkan
      if (mounted) {
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

      // Tampilkan SnackBar saat alarm dinonaktifkan
      if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Daily Reminder (11:00 AM)'),
            subtitle: _reminder
                ? const Text('Alarm aktif', style: TextStyle(color: Colors.green))
                : const Text('Alarm nonaktif', style: TextStyle(color: Colors.grey)),
            value: _reminder,
            onChanged: _toggleReminder,
          ),
        ],
      ),
    );
  }
}