import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/reminder_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reminderProvider = context.watch<ReminderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: reminderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SwitchListTile(
                  title: const Text('Daily Reminder (11:00 AM)'),
                  subtitle: reminderProvider.reminderEnabled
                      ? const Text('Alarm aktif', style: TextStyle(color: Colors.green))
                      : const Text('Alarm nonaktif', style: TextStyle(color: Colors.grey)),
                  value: reminderProvider.reminderEnabled,
                  onChanged: (value) async {
                    await reminderProvider.toggleReminder(context, value);
                  },
                ),
              ],
            ),
    );
  }
}
