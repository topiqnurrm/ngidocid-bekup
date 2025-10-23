import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mascan/core/theme.dart';

import 'package:fluttertoast/fluttertoast.dart';

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

Future<T?> showPlatformDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  String? confirmText,
  String? cancelText,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool barrierDismissible = true,
}) {
  if (context.isIOS) {
    return showCupertinoDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelText != null)
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                onCancel?.call();
              },
              child: Text(cancelText),
            ),
          if (confirmText != null)
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              child: Text(confirmText),
            ),
        ],
      ),
    );
  }
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        if (cancelText != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
            child: Text(cancelText),
          ),
        if (confirmText != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(confirmText),
          ),
      ],
    ),
  );
}
Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Confirm',
  String cancelText = 'Batal',
}) {
  return showPlatformDialog<bool>(
    context: context,
    title: title,
    content: content,
    confirmText: confirmText,
    cancelText: cancelText,
    onConfirm: () => Navigator.of(context).pop(true),
    onCancel: () => Navigator.of(context).pop(false),
  );
}
Future<void> showInfoDialog({
  required BuildContext context,
  required String title,
  required String content,
  String buttonText = 'OK',
}) {
  return showPlatformDialog(
    context: context,
    title: title,
    content: content,
    confirmText: buttonText,
  );
}
Future<void> showErrorDialog({
  required BuildContext context,
  String title = 'Kesalahan',
  required String content,
  String buttonText = 'OK',
}) {
  return showPlatformDialog(
    context: context,
    title: title,
    content: content,
    confirmText: buttonText,
  );
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    textColor: Colors.black,
    backgroundColor: Colors.orange.shade50,
    fontSize: 14.0,
  );
}

class Validator {
  static bool isValidImageFile(String filePath) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.webp', '.heic', '.heif'];
    return validExtensions.any((ext) => filePath.toLowerCase().endsWith(ext));
  }
  static bool isValidQuery(String query) {
    return query.trim().isNotEmpty && query.trim().length >= 2;
  }
  static String? validateSearchQuery(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a food name';
    }
    if (value.trim().length < 2) {
      return 'Search query must be at least 2 characters';
    }
    return null;
  }
}








