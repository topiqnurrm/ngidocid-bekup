import 'package:flutter/material.dart';
import '../data/models/restaurant.dart';
import '../data/restaurant_repository.dart';

enum LoadingState { idle, busy, error }

class RestaurantProvider extends ChangeNotifier {
  final RestaurantRepository _repo = RestaurantRepository();
  List<Restaurant> restaurants = [];
  LoadingState state = LoadingState.idle;
  String message = '';

  Future<void> loadRestaurants() async {
    state = LoadingState.busy;
    notifyListeners();
    try {
      restaurants = await _repo.getRestaurants();
      state = LoadingState.idle;
    } catch (e) {
      state = LoadingState.error;
      message = e.toString();
    }
    notifyListeners();
  }

  Future<Restaurant> getDetail(String id) => _repo.getDetail(id);

  Future<void> search(String q) async {
    state = LoadingState.busy;
    notifyListeners();
    try {
      restaurants = await _repo.search(q);
      state = LoadingState.idle;
    } catch (e) {
      state = LoadingState.error;
      message = e.toString();
    }
    notifyListeners();
  }

  Future<bool> submitReview(String id, String name, String review) async {
    try {
      final ok = await _repo.addReview(id, name, review);
      return ok;
    } catch (_) {
      return false;
    }
  }
}
