import 'package:flutter/widgets.dart';
import 'package:makanku/core/constants/restaurant_status.dart';
import 'package:makanku/features/restaurant/domain/entities/restaurant.dart';
import 'package:makanku/features/restaurant/domain/usecases/restaurant_use_case.dart';

class FavoriteProvider extends ChangeNotifier {
  final RestaurantUseCase _restaurantUseCase;

  RestaurantListResultState _resultState = RestaurantListNoneState();

  // Map untuk menyimpan status favorite dari setiap restaurant
  final Map<String, bool> _favoriteStatus = {};

  RestaurantListResultState get resultState => _resultState;

  FavoriteProvider({required RestaurantUseCase restaurantUseCase})
      : _restaurantUseCase = restaurantUseCase;

  // Method untuk mengecek apakah restaurant favorite atau tidak
  bool isFavorite(String restaurantId) {
    return _favoriteStatus[restaurantId] ?? false;
  }

  // Method untuk fetch dan update status favorite dari database
  Future<void> checkFavoriteStatus(String id) async {
    try {
      final restaurant = await _restaurantUseCase.getFavoriteById(id);
      _favoriteStatus[id] = restaurant != null;
      notifyListeners();
    } catch (e) {
      _favoriteStatus[id] = false;
      notifyListeners();
    }
  }

  // Method untuk toggle favorite status
  Future<void> toggleFavorite(String restaurantId, Restaurant restaurant) async {
    final currentStatus = _favoriteStatus[restaurantId] ?? false;

    if (currentStatus) {
      await removeFavoriteRestaurant(restaurantId);
    } else {
      await addFavoriteRestaurant(restaurant);
    }
  }

  Future<List<Restaurant>> fetchAllFavoriteRestaurants() async {
    try {
      _resultState = RestaurantListLoadingState();
      notifyListeners();
      final favorites = await _restaurantUseCase.getAllFavorites();

      // Update favorite status untuk semua restaurant yang di-fetch
      for (final restaurant in favorites) {
        _favoriteStatus[restaurant.id] = true;
      }

      if (favorites.isEmpty) {
        _resultState = RestaurantListErrorState(
          'No favorite restaurants found',
        );
        notifyListeners();
        return [];
      }

      _resultState = RestaurantListSuccessState<List<Restaurant>>(favorites);
      notifyListeners();
      return favorites;
    } catch (e) {
      _resultState = RestaurantListErrorState(
        'Failed to load favorite restaurants: $e',
      );
      notifyListeners();

      return [];
    }
  }

  Future<Restaurant?> fetchFavoriteRestaurantById(String id) async {
    try {
      final restaurant = await _restaurantUseCase.getFavoriteById(id);

      // Update status favorite
      _favoriteStatus[id] = restaurant != null;
      notifyListeners();

      return restaurant;
    } catch (e) {
      _favoriteStatus[id] = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> addFavoriteRestaurant(Restaurant restaurant) async {
    try {
      _resultState = RestaurantListLoadingState();
      notifyListeners();
      final id = await _restaurantUseCase.addFavorite(restaurant);

      if (id <= 0) {
        _resultState = RestaurantListErrorState('Failed to add favorite');
        notifyListeners();
        return;
      }

      // Update status favorite menjadi true
      _favoriteStatus[restaurant.id] = true;

      _resultState = RestaurantListSuccessState<String>(
        "success added to favorites",
      );
      notifyListeners();
    } catch (e) {
      _resultState = RestaurantListErrorState('Failed to add favorite: $e');
      notifyListeners();
    }
  }

  Future<void> removeFavoriteRestaurant(String id) async {
    try {
      _resultState = RestaurantListLoadingState();
      notifyListeners();
      final success = await _restaurantUseCase.removeFavorite(id);

      if (success <= 0) {
        _resultState = RestaurantListErrorState('Failed to remove favorite');
        notifyListeners();
        return;
      }

      // Update status favorite menjadi false
      _favoriteStatus[id] = false;

      _resultState = RestaurantListSuccessState<String>(
        "success removed from favorites",
      );
      notifyListeners();
    } catch (e) {
      _resultState = RestaurantListErrorState('Failed to remove favorite: $e');
      notifyListeners();
    }
  }

  // Method untuk clear semua status (opsional, untuk cleanup)
  void clearFavoriteStatus() {
    _favoriteStatus.clear();
    notifyListeners();
  }
}