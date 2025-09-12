import 'package:makanku/features/restaurant/data/models/restaurant_detail_model.dart';
import 'package:makanku/data/source/local/database_service.dart';
import 'package:makanku/data/source/networks/api.dart';
import 'package:makanku/features/restaurant/data/models/restaurant_detail_model.dart';
import 'package:makanku/features/restaurant/domain/entities/restaurant.dart';
import 'package:makanku/features/restaurant/domain/entities/restaurant_detail.dart';
import 'package:makanku/features/restaurant/domain/repositories/restaurant_repository.dart';

class RestaurantImpl extends RestaurantRepository {
  final Api _api;
  final DatabaseService _databaseService;

  RestaurantImpl({required Api api, required DatabaseService databaseService})
    : _api = api,
      _databaseService = databaseService;

  @override
  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      return await _api.getAllRestaurants();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    try {
      return await _api.getRestaurantDetail(id);
    } catch (e) {
      return RestaurantDetailDto.empty();
    }
  }

  @override
  Future<List<Restaurant>> getAllRestaurantsByQuery(String query) async {
    try {
      return await _api.getAllRestaurantsByQuery(query);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addReview(String id, String name, String review) async {
    try {
      await _api.addReview(id, name, review);
    } catch (e) {
      throw Exception('Failed to add review');
    }
  }

  @override
  Future<List<Restaurant>> getAllFavorites() async {
    return await _databaseService.getAllFavorites();
  }

  @override
  Future<Restaurant?> getFavoriteById(String id) async {
    return await _databaseService.getFavoriteById(id);
  }

  @override
  Future<int> addFavorite(Restaurant restaurant) async {
    return await _databaseService.addFavorite(restaurant);
  }

  @override
  Future<int> removeFavorite(String id) async {
    return await _databaseService.removeFavorite(id);
  }
}
