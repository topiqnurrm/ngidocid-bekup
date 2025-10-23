import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
