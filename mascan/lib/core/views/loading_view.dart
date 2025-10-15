import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mascan/core/theme/theme_extensions.dart';

class LoadingView extends StatelessWidget {
  final String? message;
  const LoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          context.isIOS
              ? CupertinoActivityIndicator(radius: 16)
              : CircularProgressIndicator(),
          Text(
            message ?? 'Loading data...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
