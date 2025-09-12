import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:makanku/core/constants/restaurant_status.dart';
import 'package:makanku/features/restaurant/domain/entities/restaurant.dart';
import 'package:makanku/shared/widgets/app_bar_container.dart';
import 'package:makanku/shared/widgets/restaurant_card.dart';
import 'package:makanku/features/restaurant/presentation/providers/restaurant_search_provider.dart';

class SearchScreen extends StatefulWidget {
  final String query;

  const SearchScreen({super.key, required this.query});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      // Assuming you have a method to fetch search results based on the query
      context.read<SearchProvider>().fetchRestaurantsByQuery(widget.query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const AppBarContainer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Search Results for "${widget.query}"',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, child) {
                return switch (provider.resultState) {
                  RestaurantListLoadingState() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  RestaurantListErrorState errorState => Center(
                    child: Text(errorState.message),
                  ),
                  RestaurantListSuccessState<List<Restaurant>> successState =>
                    ListView.builder(
                      itemCount: successState.data.length,
                      itemBuilder: (context, index) {
                        final restaurant = successState.data[index];
                        return ListRestaurantCard(
                          id: restaurant.id,
                          name: restaurant.name,
                          description: restaurant.description,
                          imageUrl:
                              "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
                          city: restaurant.city,
                          rating: restaurant.rating,
                        );
                      },
                    ),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
