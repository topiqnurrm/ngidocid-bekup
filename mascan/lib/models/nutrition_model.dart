import 'package:json_annotation/json_annotation.dart';

part 'nutrition_model.g.dart';

@JsonSerializable()
class Nutrition {
  final int calories;
  final int protein;
  final int fat;
  final int carbs;
  final int fiber;

  Nutrition({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) =>
      _$NutritionFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionToJson(this);
}
