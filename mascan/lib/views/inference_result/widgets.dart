import 'package:flutter/material.dart';
import 'package:mascan/models.dart';
import 'package:gap/gap.dart';

class BestInferenceResultCard extends StatelessWidget {
  final FoodPrediction food;
  const BestInferenceResultCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          '/food-recipe',
          arguments: {'foodLabel': food.label},
        ),
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber.shade700, size: 24),
                  Gap(8),
                  Text(
                    'Hasil Terbaik',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
              Gap(12),
              Text(
                food.label,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.blue.shade900,
                ),
              ),
              Gap(4),
              Row(
                children: [
                  Text(
                    'Kecocokan: ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                  ),
                  Text(
                    food.confidencePercentage,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InferenceResultItem extends StatelessWidget {
  final FoodPrediction prediction;
  final int index;
  final VoidCallback onTap;

  const InferenceResultItem({
    super.key,
    required this.prediction,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            spacing: 12,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      prediction.label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    LinearProgressIndicator(
                      value: prediction.confidence,
                      borderRadius: BorderRadius.circular(8),
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    ),
                  ],
                ),
              ),
              Text(
                prediction.confidencePercentage,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
