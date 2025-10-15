import 'dart:convert';

import 'package:mascan/core/configs/env.dart';
import 'package:mascan/models/nutrition_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel model;

  GeminiService() {
    final geminiApiKey = Env.geminiApiKey;
    final geminiModel = Env.geminiModel;

    if (geminiApiKey.isEmpty) {
      throw Exception(
        'Gemini API key is not set in the environment variables.',
      );
    }

    model = GenerativeModel(
      model: geminiModel,
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0,
        responseMimeType: 'application/json',
        responseSchema: Schema(
          SchemaType.object,
          requiredProperties: ["nutrition"],
          properties: {
            "nutrition": Schema(
              SchemaType.object,
              requiredProperties: [
                "calories",
                "carbs",
                "protein",
                "fat",
                "fiber",
              ],
              properties: {
                "calories": Schema(SchemaType.number),
                "carbs": Schema(SchemaType.number),
                "protein": Schema(SchemaType.number),
                "fat": Schema(SchemaType.number),
                "fiber": Schema(SchemaType.number),
              },
            ),
          },
        ),
      ),
    );
  }

  Future<Nutrition> generateNutrition(String foodLabel) async {
    final prompt = 'Nama makanannya adalah $foodLabel';
    final systemInstruction =
        'Saya adalah suatu mesin yang mampu mengidentifikasi nutrisi atau kandungan gizi pada makanan layaknya uji laboratorium makanan. Hal yang bisa diidentifikasi adalah kalori, karbohidrat, lemak, serat, dan protein pada makanan. Satuan dari indikator tersebut berupa gram.';
    final content = [Content.text(systemInstruction), Content.text(prompt)];

    try {
      final response = await model.generateContent(content);

      if (response.text == null) {
        throw Exception('No response from Gemini API');
      }

      return Nutrition.fromJson(json.decode(response.text!)['nutrition']);
    } catch (e) {
      throw Exception('Failed to parse nutrition data: $e');
    }
  }
}
