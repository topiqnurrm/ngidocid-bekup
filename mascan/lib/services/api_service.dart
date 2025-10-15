import 'package:dio/dio.dart';
import 'package:mascan/core/exceptions/app_exceptions.dart';
import 'package:mascan/core/exceptions/exception_handler.dart';
import 'package:mascan/models/food_recipe_model.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<FoodRecipe?> searchFood(String query) async {
    try {
      final response = await _dio.get('search.php?s=$query');

      final result = response.data['meals'] as List?;

      if (result == null) return null;

      return result.map((json) => FoodRecipe.fromJson(json)).first;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } on ParseException {
      rethrow;
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e as Exception);
    }
  }
}
