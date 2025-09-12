import 'package:makanku/features/restaurant/domain/entities/restaurant.dart';
import 'package:makanku/features/restaurant/domain/entities/restaurant_detail.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> getAllRestaurants();
  Future<RestaurantDetail> getRestaurantDetail(String id);
  Future<List<Restaurant>> getAllRestaurantsByQuery(String query);
  Future<void> addReview(String id, String name, String review);
  Future<List<Restaurant>> getAllFavorites();
  Future<Restaurant?> getFavoriteById(String id);
  Future<int> addFavorite(Restaurant restaurant);
  Future<int> removeFavorite(String id);
}
