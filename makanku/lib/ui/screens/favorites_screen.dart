import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorite_provider.dart';
import '../widgets/restaurant_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: fav.favs.isEmpty ? const Center(child: Text('No favorites yet')) : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: fav.favs.length,
        itemBuilder: (context, idx) {
          final r = fav.favs[idx];
          return RestaurantCard(restaurant: r);
        },
      ),
    );
  }
}
