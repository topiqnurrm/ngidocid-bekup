import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:flutter/cupertino.dart';
import 'package:mascan/init/theme.dart';

class ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const ErrorView({super.key, required this.error, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 64),
            Gap(16),
            Text('Kesalahan', style: Theme.of(context).textTheme.headlineSmall),
            Gap(8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            Gap(24),
            OutlinedButton.icon(
              icon: Icon(Icons.refresh),
              onPressed: onRetry,
              label: Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

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
            message ?? 'Memuat data...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class NoResultView extends StatelessWidget {
  final String description;
  const NoResultView({super.key, required this.description});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                Gap(16),
                Text(
                  'Hasil tidak ditemukan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Gap(8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}