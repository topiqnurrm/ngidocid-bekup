import 'package:flutter/material.dart';
import '../data/models/restaurant.dart';
import '../data/db/database_helper.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  final _db = DatabaseHelper.instance;
  List<Restaurant> _favs = [];
  List<Restaurant> get favs => List.unmodifiable(_favs);

  FavoriteProvider() {
    _load();
  }

  Future<void> _load() async {
    try {
      final fromDb = await _db.getFavorites();
      if (fromDb.isNotEmpty) {
        _favs = fromDb;
        notifyListeners();
        return;
      }
    } catch (_) {
      // ignore DB errors and fallback to shared prefs
    }

    // fallback to shared preferences (migration)
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString('makanku_favs');
    if (s != null) {
      try {
        final lst = (json.decode(s) as List).map((e) => Restaurant.fromJson(Map<String, dynamic>.from(e))).toList();
        _favs = lst;
        // store to db for future
        for (final r in _favs) {
          await _db.insertFavorite(r);
        }
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> toggle(Restaurant r) async {
    final exists = _favs.any((e) => e.id == r.id);
    if (exists) {
      _favs.removeWhere((e) => e.id == r.id);
      await _db.removeFavorite(r.id);
    } else {
      _favs.add(r);
      await _db.insertFavorite(r);
    }
    // update shared prefs for backward compat
    final sp = await SharedPreferences.getInstance();
    sp.setString('makanku_favs', json.encode(_favs.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favs.any((e) => e.id == id);
  }
}
