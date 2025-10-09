
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/restaurant.dart';

class ApiService {
  static const String _base = 'https://restaurant-api.dicoding.dev';

  Future<List<Restaurant>> fetchList() async {
    final res = await http.get(Uri.parse('$_base/list'));
    if (res.statusCode == 200) {
      final j = json.decode(res.body);
      final items = (j['restaurants'] as List).map((e) => Restaurant.fromJson(Map<String, dynamic>.from(e))).toList();
      return items;
    }
    throw Exception('Failed to load list');
  }

  Future<Restaurant> fetchDetail(String id) async {
    final res = await http.get(Uri.parse('$_base/detail/$id'));
    if (res.statusCode == 200) {
      final j = json.decode(res.body);
      return Restaurant.fromJson(Map<String, dynamic>.from(j['restaurant']));
    }
    throw Exception('Failed to load detail');
  }

  Future<List<Restaurant>> search(String q) async {
    final res = await http.get(Uri.parse('$_base/search?q=$q'));
    if (res.statusCode == 200) {
      final j = json.decode(res.body);
      final items = (j['restaurants'] as List).map((e) => Restaurant.fromJson(Map<String, dynamic>.from(e))).toList();
      return items;
    }
    throw Exception('Search failed');
  }

  Future<bool> postReview(String id, String name, String review) async {
    final body = json.encode({'id': id, 'name': name, 'review': review});
    final res = await http.post(Uri.parse('$_base/review'), headers: {'Content-Type': 'application/json'}, body: body);
    if (res.statusCode == 201 || res.statusCode == 200) {
      return true;
    }
    return false;
  }
}
