import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mascan/core/theme/theme_extensions.dart';

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
