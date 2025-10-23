import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mascan/init/views.dart';
import 'package:mascan/init/widgets.dart';
import 'package:mascan/models.dart';
import 'package:mascan/seemodel/modelsview.dart';
import 'package:mascan/views/bumbu/widgets.dart';
import 'package:gap/gap.dart';

class FoodRecipeView extends ConsumerStatefulWidget {
  const FoodRecipeView({super.key});

  @override
  ConsumerState<FoodRecipeView> createState() => _FoodRecipeViewState();
}

class _FoodRecipeViewState extends ConsumerState<FoodRecipeView> {
  String? foodLabel;

  Future<void> _getFoodRecipe(String foodLabel) async {
    await ref.read(foodViewModelProvider.notifier).searchFood(foodLabel);
  }

  Future<void> _generateNutritionFacts(String foodLabel) async {
    await ref
        .read(geminiViewModelProvider.notifier)
        .generateResponse(foodLabel);
  }

  Future<void> _fetchData() async {
    if (foodLabel != null) {
      await _getFoodRecipe(foodLabel!);
      await _generateNutritionFacts(foodLabel!);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      foodLabel = args?['foodLabel'] as String?;

      _fetchData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodState = ref.watch(foodViewModelProvider);

    Widget body;
    if (foodState.error != null) {
      body = ErrorView(error: foodState.error!, onRetry: _fetchData);
    } else if (foodState.isLoading) {
      body = LoadingView();
    } else if (foodState.foodRecipe != null) {
      body = _buildContent(foodRecipe: foodState.foodRecipe!);
    } else {
      body = NoResultView(description: 'Tidak ditemukan resep untuk makanan ini.');
    }

    return AppScaffold(title: Text('Makanan Resep'), body: body);
  }

  Widget _buildContent({required FoodRecipe foodRecipe}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Gap(8),
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(foodRecipe.strMealThumb),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Center(
            child: Text(
              foodRecipe.strMeal,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  foodRecipe.strCategory,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Row(
                spacing: 4,
                children: [
                  Icon(
                    Icons.location_pin,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  Text(
                    foodRecipe.strArea,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Gap(4),

          NutritionFacts(foodLabel: foodRecipe.strMeal),

          Text(
            'Bahan-bahan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          IngredientsList(recipe: foodRecipe),

          Text(
            'Panduan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          Text(
            foodRecipe.strInstructions,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          Gap(16),
        ],
      ),
    );
  }
}
