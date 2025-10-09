import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _dailyReminderEnabled = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final enabled = await NotificationService().isDailyReminderEnabled();
    setState(() {
      _dailyReminderEnabled = enabled;
      _loading = false;
    });
  }

  Future<void> _onToggle(bool value) async {
    setState(() {
      _dailyReminderEnabled = value;
    });
    await NotificationService().setDailyReminderEnabled(value);
    // Optionally show feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(value ? 'Daily reminder diaktifkan' : 'Daily reminder dinonaktifkan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            children: [
              SwitchListTile(
                title: const Text('Daily lunch reminder (11:00 AM)'),
                subtitle: const Text('Ingatkan makan siang setiap hari pada pukul 11:00'),
                value: _dailyReminderEnabled,
                onChanged: _onToggle,
              ),
              const ListTile(
                title: Text('Catatan'),
                subtitle: Text('Mode penjadwalan Android dapat membutuhkan izin "exact alarms" untuk benar-benar tepat waktu. Jika notifikasi tidak muncul tepat waktu pada beberapa perangkat, periksa pengaturan penghemat baterai/perizinan.')
              ),
            ],
          ),
    );
  }
}
