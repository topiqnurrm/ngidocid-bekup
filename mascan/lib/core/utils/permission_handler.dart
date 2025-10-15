import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  static Future<bool> checkCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  static Future<void> openAppSettings() async {
    await AppSettings.openAppSettings();
  }

  static Future<bool> handlePermissionDenied(Permission permission) async {
    final isPermanentlyDenied =
        await permission.isPermanentlyDenied || await permission.isDenied;

    if (isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    final status = await permission.request();
    return status.isGranted;
  }
}
