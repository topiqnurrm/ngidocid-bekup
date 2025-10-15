import 'package:flutter/material.dart';
import 'package:mascan/models/food_recipe_model.dart';

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
