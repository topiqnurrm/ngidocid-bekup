import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/restaurant_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/theme_provider.dart';
import '../widgets/restaurant_card.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final prov = Provider.of<RestaurantProvider>(context, listen: false);
    prov.loadRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<RestaurantProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Makanku'),
        actions: [
          IconButton(
            tooltip: theme.isDark ? 'Switch to light mode' : 'Switch to dark mode',
            icon: Icon(theme.isDark ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: () => theme.toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FavoritesScreen())),
          ),
        ],
      ),
      body: Builder(builder: (ctx) {
        if (prov.state == LoadingState.busy) {
          return const Center(child: CircularProgressIndicator());
        } else if (prov.state == LoadingState.error) {
          return Center(child: Text('Error: ${prov.message}'));
        } else if (prov.restaurants.isEmpty) {
          return const Center(child: Text('No restaurants found'));
        }
        return RefreshIndicator(
          onRefresh: prov.loadRestaurants,
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: prov.restaurants.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, idx) {
              final r = prov.restaurants[idx];
              return GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(id: r.id))),
                child: RestaurantCard(restaurant: r),
              );
            },
          ),
        );
      }),
    );
  }
}
