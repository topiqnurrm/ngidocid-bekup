import 'package:flutter/material.dart';
import '../data/models/restaurant.dart';
import '../data/restaurant_repository.dart';

enum LoadingState { idle, busy, error }

class RestaurantProvider extends ChangeNotifier {
  final RestaurantRepository _repo;
  RestaurantProvider({RestaurantRepository? repo}) : _repo = repo ?? RestaurantRepository();


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
      message =
      'Oops… Something went wrong. Please check your internet connection and try again.';
    }

    notifyListeners();
  }

  /// **Method pencarian restoran**
  Future<void> search(String query) async {
    if (query.isEmpty) {
      // Jika query kosong, muat daftar restoran utama kembali
      await loadRestaurants();
      return;
    }

    state = LoadingState.busy;
    message = '';
    notifyListeners();

    try {
      // Panggil repository search
      restaurants = await _repo.search(query);
      state = LoadingState.idle;
      if (restaurants.isEmpty) {
        message = 'No results';
      }
    } catch (e) {
      state = LoadingState.error;
      message =
      'Oops… Something went wrong while searching. Please check your internet connection and try again.';
    }

    notifyListeners();
  }

  Future<Restaurant?> getDetail(String id) async {
    try {
      return await _repo.getDetail(id);
    } catch (e) {
      state = LoadingState.error;
      message =
      'Oops… Something went wrong. Please check your internet connection and try again.';
      notifyListeners();
      return null;
    }
  }

  Future<bool> submitReview(String id, String name, String review) async {
    try {
      final ok = await _repo.addReview(id, name, review);
      return ok;
    } catch (e) {
      message =
      'Failed to submit review. Please check your internet connection.';
      notifyListeners();
      return false;
    }
  }
}
