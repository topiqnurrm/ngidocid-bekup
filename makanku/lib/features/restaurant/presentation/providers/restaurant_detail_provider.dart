import 'package:flutter/material.dart';
import 'package:makanku/core/constants/restaurant_status.dart';
import 'package:makanku/features/restaurant/domain/entities/restaurant_detail.dart';
import 'package:makanku/features/restaurant/domain/usecases/restaurant_use_case.dart';

class DetailProvider extends ChangeNotifier {
  final RestaurantUseCase _restaurantUseCase;

  RestaurantListResultState _resultState = RestaurantListNoneState();
  bool _isLoading = false;

  RestaurantListResultState get resultState => _resultState;
  bool get isLoading => _isLoading;

  DetailProvider({required RestaurantUseCase restaurantUseCase})
      : _restaurantUseCase = restaurantUseCase;

  Future<void> fetchRestaurantDetails(String restaurantId) async {
    try {
      _resultState = RestaurantListLoadingState();
      notifyListeners();

      final restaurant = await _restaurantUseCase.getRestaurantDetail(
        restaurantId,
      );

      if (restaurant.id.isEmpty) {
        _resultState = RestaurantListErrorState('Restaurant not found');
        notifyListeners();
        return;
      }

      _resultState = RestaurantListSuccessState<RestaurantDetail>(restaurant);
      notifyListeners();
    } catch (e) {
      _resultState = RestaurantListErrorState(
        'Failed to load restaurant details: $e',
      );
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addReview(String id, String name, String review) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _restaurantUseCase.addReview(id, name, review);

      // Refresh restaurant details to get updated reviews
      await fetchRestaurantDetails(id);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resultState = RestaurantListErrorState('Failed to add review: $e');
      notifyListeners();
      rethrow;
    }
  }
}