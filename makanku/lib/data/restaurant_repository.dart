import 'api_service.dart';
import 'models/restaurant.dart';

class RestaurantRepository {
  final ApiService api;
  RestaurantRepository({ApiService? api}) : api = api ?? ApiService();

  Future<List<Restaurant>> getRestaurants() => api.fetchList();
  Future<Restaurant> getDetail(String id) => api.fetchDetail(id);
  Future<List<Restaurant>> search(String q) => api.search(q);

  Future<bool> addReview(String id, String name, String review) => api.postReview(id, name, review);
}
