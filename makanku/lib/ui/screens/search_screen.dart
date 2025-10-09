
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/restaurant_provider.dart';
import '../widgets/restaurant_card.dart';
import 'detail_screen.dart';
import 'error_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<RestaurantProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(children: [
              Expanded(child: TextField(controller: _ctrl, decoration: const InputDecoration(hintText: 'Search restaurants'))),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () => prov.search(_ctrl.text.trim()), child: const Text('Search')),
            ]),
          ),
          Expanded(child: Builder(builder: (context) {
            if (prov.state == LoadingState.busy) return const Center(child: CircularProgressIndicator());
            if (prov.state == LoadingState.error) return ErrorScreen(message: prov.message, onRetry: () => prov.loadRestaurants());
            if (prov.restaurants.isEmpty) return const Center(child: Text('No results'));
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: prov.restaurants.length,
              itemBuilder: (context, idx) {
                final r = prov.restaurants[idx];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(id: r.id))),
                  child: RestaurantCard(restaurant: r),
                );
              },
            );
          })),
        ],
      ),
    );
  }
}
