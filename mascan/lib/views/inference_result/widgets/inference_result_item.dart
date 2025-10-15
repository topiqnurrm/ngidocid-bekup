import 'package:flutter/material.dart';
import 'package:mascan/models/food_prediction_model.dart';

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
