
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
    message = '';
    notifyListeners();
    try {
      restaurants = await _repo.getRestaurants();
      state = LoadingState.idle;
    } catch (e) {
      state = LoadingState.error;
      message = 'Failed to load restaurants. Please check your internet connection.';
    }
    notifyListeners();
  }

  Future<Restaurant> getDetail(String id) async {
    try {
      return await _repo.getDetail(id);
    } catch (e) {
      throw Exception('Failed to load restaurant detail. Please try again.');
    }
  }

  Future<void> search(String q) async {
    state = LoadingState.busy;
    notifyListeners();
    try {
      restaurants = await _repo.search(q);
      state = LoadingState.idle;
    } catch (e) {
      state = LoadingState.error;
      message = 'Search failed. Please try again.';
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
