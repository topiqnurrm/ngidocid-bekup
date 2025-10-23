import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
