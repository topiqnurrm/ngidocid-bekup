import 'package:flutter/material.dart';
import '../../data/models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCard({required this.restaurant, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(children: [
          if (restaurant.pictureId.isNotEmpty) ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network('https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}', width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(restaurant.name, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text('${restaurant.city} • ${restaurant.rating}', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Text(restaurant.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ))
        ],),
      ),
    );
  }
}
