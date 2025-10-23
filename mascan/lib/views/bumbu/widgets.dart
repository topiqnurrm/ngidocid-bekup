import 'package:flutter/material.dart';
import 'package:mascan/models.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mascan/init/theme.dart';
import 'package:mascan/seemodel/modelsview.dart';
import 'package:gap/gap.dart';

class IngredientsList extends StatelessWidget {
  final FoodRecipe recipe;
  const IngredientsList({super.key, required this.recipe});
  @override
  Widget build(BuildContext context) {
    final List<Widget> ingredients = [];
    final ingredientFields = List.generate(
      20,
          (i) => recipe.toJson()['strIngredient${i + 1}'],
    );
    final measureFields = List.generate(
      20,
          (i) => recipe.toJson()['strMeasure${i + 1}'],
    );
    for (int i = 0; i < ingredientFields.length; i++) {
      final ingredient = ingredientFields[i];
      final measure = measureFields[i];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 6),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${measure?.isNotEmpty == true ? '$measure ' : ''}$ingredient',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients,
    );
  }
}

class NutritionFacts extends ConsumerStatefulWidget {
  final String foodLabel;
  const NutritionFacts({super.key, required this.foodLabel});
  @override
  ConsumerState<NutritionFacts> createState() => _FoodContentState();
}
class _FoodContentState extends ConsumerState<NutritionFacts> {
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final geminiState = ref.watch(geminiViewModelProvider);
    if (geminiState.isLoading == true) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            context.isIOS
                ? CupertinoActivityIndicator(radius: 12)
                : SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ),
            Text(
              'Mengambil informasi nutrisi...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Gap(4),
          ],
        ),
      );
    } else if (geminiState.error != null) {
      return Center(
        child: Text('Terjadi kesalahan saat mengambil data nutrisi: ${geminiState.error}'),
      );
    } else if (geminiState.nutrition != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(
            'Fakta Nutrisi',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Gap(4),
          SizedBox(
            width: double.infinity,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 6,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        Text(
                          'Dihasilkan oleh Gemini AI',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    Gap(4),
                    Text('Kalori: ${geminiState.nutrition!.calories} kcal'),
                    Text('Protein: ${geminiState.nutrition!.protein} g'),
                    Text('Karbohidrat: ${geminiState.nutrition!.carbs} g'),
                    Text('Lemak: ${geminiState.nutrition!.fat} g'),
                    Text('Serat: ${geminiState.nutrition!.fiber} g'),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
