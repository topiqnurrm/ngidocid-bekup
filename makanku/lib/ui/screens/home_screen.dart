import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/restaurant_provider.dart';
import '../../providers/theme_provider.dart';
import '../widgets/restaurant_card.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';
import 'error_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<RestaurantProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Makanku'),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen())
              )
          ),
          Consumer<ThemeProvider>(
              builder: (context, t, __) => IconButton(
                  icon: Icon(t.isDark ? Icons.dark_mode : Icons.light_mode),
                  onPressed: () => t.toggle()
              )
          ),
          IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FavoritesScreen())
              )
          ),
          IconButton(
            icon: const Icon(Icons.alarm),
            tooltip: 'Pengingat',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Builder(builder: (context) {
        if (prov.state == LoadingState.busy) return const Center(child: CircularProgressIndicator());
        if (prov.state == LoadingState.error) return ErrorScreen(message: prov.message, onRetry: prov.loadRestaurants);
        if (prov.restaurants.isEmpty) return const Center(child: Text('No restaurants available'));
        return RefreshIndicator(
            onRefresh: () => prov.loadRestaurants(),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: prov.restaurants.length,
              itemBuilder: (context, idx) {
                final r = prov.restaurants[idx];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => DetailScreen(id: r.id))
                  ),
                  child: RestaurantCard(restaurant: r),
                );
              },
            )
        );
      }),
    );
  }
}