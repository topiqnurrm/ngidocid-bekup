
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/restaurant.dart';
import 'dart:convert';

class FavoriteProvider extends ChangeNotifier {
  static const _key = 'makanku_favs';
  List<Restaurant> _favs = [];
  List<Restaurant> get favs => List.unmodifiable(_favs);

  FavoriteProvider() {
    _load();
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString(_key);
    if (s != null) {
      try {
        final List decoded = json.decode(s);
        _favs = decoded.map((e) => Restaurant.fromJson(Map<String, dynamic>.from(e))).toList();
      } catch (_) {
        _favs = [];
      }
    }
    notifyListeners();
  }

  Future<void> toggle(Restaurant r) async {
    final exists = _favs.any((e) => e.id == r.id);
    if (exists) {
      _favs.removeWhere((e) => e.id == r.id);
    } else {
      _favs.add(r);
    }
    final sp = await SharedPreferences.getInstance();
    sp.setString(_key, json.encode(_favs.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  bool isFavorite(String id) => _favs.any((e) => e.id == id);
}
