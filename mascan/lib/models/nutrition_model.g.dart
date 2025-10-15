// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Nutrition _$NutritionFromJson(Map<String, dynamic> json) => Nutrition(
  calories: (json['calories'] as num).toInt(),
  protein: (json['protein'] as num).toInt(),
  fat: (json['fat'] as num).toInt(),
  carbs: (json['carbs'] as num).toInt(),
  fiber: (json['fiber'] as num).toInt(),
);

Map<String, dynamic> _$NutritionToJson(Nutrition instance) => <String, dynamic>{
  'calories': instance.calories,
  'protein': instance.protein,
  'fat': instance.fat,
  'carbs': instance.carbs,
  'fiber': instance.fiber,
};
