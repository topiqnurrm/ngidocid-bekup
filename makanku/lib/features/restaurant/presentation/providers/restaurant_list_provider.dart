import 'package:flutter/widgets.dart';
import 'package:makanku/core/constants/restaurant_status.dart';
import 'package:makanku/features/restaurant/domain/entities/restaurant.dart';
import 'package:makanku/features/restaurant/domain/usecases/restaurant_use_case.dart';


class HomeProvider extends ChangeNotifier {
  final RestaurantUseCase _restaurantUseCase;

  RestaurantListResultState _resultState = RestaurantListNoneState();

  RestaurantListResultState get resultState => _resultState;

  HomeProvider({required RestaurantUseCase restaurantUseCase})
    : _restaurantUseCase = restaurantUseCase;

  Future<List<Restaurant>> fetchAllRestaurants() async {
    try {
      _resultState = RestaurantListLoadingState();
      notifyListeners();
      final restaurants = await _restaurantUseCase.getAllRestaurants();

      if (restaurants.isEmpty) {
        _resultState = RestaurantListErrorState('No restaurants found');
        notifyListeners();
        return [];
      }

      _resultState = RestaurantListSuccessState<List<Restaurant>>(restaurants);
      notifyListeners();
      return restaurants;
    } catch (e) {
      _resultState = RestaurantListErrorState('Failed to load restaurants: $e');
      notifyListeners();

      return [];
    }
  }
}
