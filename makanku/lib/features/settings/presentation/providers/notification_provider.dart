import 'package:flutter/widgets.dart';
import 'package:makanku/core/services/local_notification_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;

  LocalNotificationProvider(this.flutterNotificationService);

  int _notificationId = 0;
  bool? _permission = false;
  bool? get permission => _permission;

  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

  void scheduleDailyElevenAMNotification() {
    _notificationId += 1;
    flutterNotificationService.scheduleDailyElevenAMNotification(
      id: _notificationId,
    );
  }
}
