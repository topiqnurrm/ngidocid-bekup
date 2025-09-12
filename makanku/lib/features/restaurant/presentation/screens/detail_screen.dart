import 'package:flutter/material.dart';
import 'package:makanku/core/constants/restaurant_status.dart';
import 'package:makanku/features/restaurant/domain/entities/restaurant_detail.dart';
import 'package:makanku/features/restaurant/presentation/screens/body_detail_screen.dart';
import 'package:makanku/shared/widgets/app_bar_container.dart';
import 'package:makanku/features/restaurant/presentation/providers/restaurant_detail_provider.dart';
import 'package:makanku/features/favorite/presentation/providers/favorite_provider.dart';
import 'package:provider/provider.dart';


class DetailScreen extends StatefulWidget {
  final String id;

  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      // Fetch restaurant details
      context.read<DetailProvider>().fetchRestaurantDetails(widget.id);

      // Fetch favorite status
      context.read<FavoriteProvider>().fetchFavoriteRestaurantById(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const AppBarContainer(),
      body: Consumer2<DetailProvider, FavoriteProvider>(
        builder: (context, detailProvider, favoriteProvider, child) {
          return switch (detailProvider.resultState) {
            RestaurantListLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            RestaurantListErrorState errorState => Center(
              child: Text(errorState.message),
            ),
            RestaurantListSuccessState<RestaurantDetail> successState =>
                BodyDetailScreen(data: successState.data),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}