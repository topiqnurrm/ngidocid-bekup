import 'package:flutter/foundation.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isAutoSchedulingEnabled = false;

  bool get isAutoSchedulingEnabled => _isAutoSchedulingEnabled;

  // Method untuk mengubah status auto scheduling
  void setAutoScheduling(bool value) {
    _isAutoSchedulingEnabled = value;
    notifyListeners();

    // Di sini Anda bisa menambahkan logic untuk:
    // - Menyimpan setting ke SharedPreferences/Database
    // - Mengatur/membatalkan notifikasi
    _saveAutoSchedulingSetting(value);
  }

  // Method untuk toggle auto scheduling
  void toggleAutoScheduling() {
    setAutoScheduling(!_isAutoSchedulingEnabled);
  }

  // Method untuk load setting dari storage (panggil di initState atau constructor)
  Future<void> loadSettings() async {
    try {
      // Load dari SharedPreferences atau database
      _isAutoSchedulingEnabled = await _loadAutoSchedulingSetting();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  // Private method untuk menyimpan setting
  Future<void> _saveAutoSchedulingSetting(bool value) async {
    try {
      // Implementasi penyimpanan ke SharedPreferences
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('auto_scheduling_enabled', value);

      // Jika enabled, setup notifikasi
      if (value) {
        _setupDailyNotification();
      } else {
        _cancelDailyNotification();
      }

      debugPrint('Auto scheduling setting saved: $value');
    } catch (e) {
      debugPrint('Error saving auto scheduling setting: $e');
    }
  }

  // Private method untuk load setting
  Future<bool> _loadAutoSchedulingSetting() async {
    try {
      // Implementasi load dari SharedPreferences
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // return prefs.getBool('auto_scheduling_enabled') ?? false;

      return false; // Default value
    } catch (e) {
      debugPrint('Error loading auto scheduling setting: $e');
      return false;
    }
  }

  // Method untuk setup notifikasi harian
  void _setupDailyNotification() {
    // Implementasi setup notifikasi pada jam 11 pagi
    debugPrint('Setting up daily notification at 11 AM');

    // Contoh implementasi dengan flutter_local_notifications:
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   0,
    //   'Restaurant Reminder',
    //   'Don\'t forget to check new restaurants today!',
    //   _nextInstanceOfElevenAM(),
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'daily_notification',
    //       'Daily Notifications',
    //       channelDescription: 'Daily restaurant reminder notifications',
    //     ),
    //   ),
    //   androidAllowWhileIdle: true,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    //   matchDateTimeComponents: DateTimeComponents.time,
    // );
  }

  // Method untuk membatalkan notifikasi
  void _cancelDailyNotification() {
    // Implementasi cancel notifikasi
    debugPrint('Cancelling daily notification');

    // Contoh implementasi:
    // await flutterLocalNotificationsPlugin.cancel(0);
  }

// Helper method untuk mendapatkan waktu 11 AM berikutnya
// TZDateTime _nextInstanceOfElevenAM() {
//   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//   tz.TZDateTime scheduledDate =
//       tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);
//   if (scheduledDate.isBefore(now)) {
//     scheduledDate = scheduledDate.add(const Duration(days: 1));
//   }
//   return scheduledDate;
// }
}