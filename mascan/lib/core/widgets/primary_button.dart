import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mascan/core/theme/theme_extensions.dart';
import 'package:icons_plus/icons_plus.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  const PrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        color: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.symmetric(vertical: 12),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onPrimary, // atur warna ikon di sini
              ),
            Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary), // warna teks
            ),
          ],
        ),
      );

      // return CupertinoButton(
      //   onPressed: onPressed,
      //   foregroundColor: Theme.of(context).colorScheme.onPrimary,
      //   color: Theme.of(context).colorScheme.primary,
      //   padding: EdgeInsets.symmetric(vertical: 12),
      //   borderRadius: BorderRadius.circular(8),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     spacing: 4,
      //     children: [
      //       Icon(HeroIcons.document_magnifying_glass),
      //       Text('Analyze Image'),
      //     ],
      //   ),
      // );
    } else {
      return MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              icon != null ? Icon(icon) : Container(),
              Text('Analyze Image'),
            ],
          ),
        ),
      );
    }
  }
}
