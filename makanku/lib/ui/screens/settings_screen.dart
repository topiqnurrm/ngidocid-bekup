import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
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
      await NotificationHelper.scheduleDailyNotification(id: 0, hour: 11, minute: 0, title: 'Lunch time', body: 'Don\'t forget to have your lunch!');
    } else {
      await NotificationHelper.cancel(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: theme.isDark,
            onChanged: (_) => theme.toggle(),
          ),
          SwitchListTile(
            title: const Text('Daily Reminder (11:00 AM)'),
            value: _reminder,
            onChanged: _toggleReminder,
          ),
        ],
      ),
    );
  }
}
