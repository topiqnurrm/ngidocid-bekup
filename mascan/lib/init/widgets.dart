import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mascan/init/theme.dart';

class AppScaffold extends StatelessWidget {
  final Widget? title;
  final Widget body;
  final List<Widget>? actions;
  final bool? automaticallyImplyLeading;
  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.automaticallyImplyLeading,
  });
  @override
  Widget build(BuildContext context) {
    return context.isIOS
        ? CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: automaticallyImplyLeading ?? true,
        leading: automaticallyImplyLeading ?? true
            ? CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.navigate_before, size: 32),
        )
            : null,
        middle: title ?? Container(),
        trailing: actions?.isNotEmpty == true
            ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(child: body),
      ),
    )
        : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading ?? true,
        title: title ?? Container(),
        actions: actions,
        leading: automaticallyImplyLeading ?? true
            ? IconButton(
          icon: const Icon(Icons.navigate_before, size: 32),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: 'Back',
        )
            : null,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(child: body),
      ),
    );
  }
}

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
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ],
        ),
      );
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
              Text('Analisis gambar'),
            ],
          ),
        ),
      );
    }
  }
}

class PrimaryOutlinedButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  const PrimaryOutlinedButton({
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
        padding: EdgeInsets.symmetric(vertical: 12),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              if (icon != null)
                Icon(icon, color: Theme.of(context).colorScheme.primary),
              Text(
                label,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
      );
    } else {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [icon != null ? Icon(icon) : Container(), Text(label)],
        ),
      );
    }
  }
}