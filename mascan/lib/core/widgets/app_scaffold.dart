import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mascan/core/theme/theme_extensions.dart';

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
