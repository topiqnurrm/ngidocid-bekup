import 'package:flutter/material.dart';
import 'package:mascan/models/food_prediction_model.dart';
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
                    'Best Match',
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
                    'Confidence: ',
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
