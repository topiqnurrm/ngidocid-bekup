import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/restaurant_provider.dart';
import '../../providers/favorite_provider.dart';
import '../widgets/restaurant_card.dart';
import '../../data/models/restaurant.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  const DetailScreen({required this.id, super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Restaurant? restaurant;
  bool loading = true;
  String error = '';
  final _nameCtrl = TextEditingController();
  final _reviewCtrl = TextEditingController();
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { loading = true; });
    try {
      final rp = Provider.of<RestaurantProvider>(context, listen: false);
      restaurant = await rp.getDetail(widget.id);
    } catch (e) {
      error = e.toString();
    } finally {
      setState(() { loading = false; });
    }
  }

  Future<void> _submit() async {
    if (_nameCtrl.text.trim().isEmpty || _reviewCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill name and review')));
      return;
    }
    setState((){ submitting = true; });
    final rp = Provider.of<RestaurantProvider>(context, listen: false);
    final ok = await rp.submitReview(widget.id, _nameCtrl.text.trim(), _reviewCtrl.text.trim());
    setState((){ submitting = false; });
    if (ok) {
      _nameCtrl.clear();
      _reviewCtrl.clear();
      await _load(); // refresh detail to get latest reviews
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review submitted')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to submit review')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final fav = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: loading ? const Center(child: CircularProgressIndicator()) : (error.isNotEmpty ? Center(child: Text('Error: $error')) :
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(restaurant!.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('City: ${restaurant!.city} - Rating: ${restaurant!.rating}'),
            const SizedBox(height: 12),
            if (restaurant!.pictureId.isNotEmpty) Image.network('https://restaurant-api.dicoding.dev/images/medium/${restaurant!.pictureId}'),
            const SizedBox(height: 12),
            Text(restaurant!.description),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(fav.isFavorite(restaurant!.id) ? Icons.favorite : Icons.favorite_border),
              label: Text(fav.isFavorite(restaurant!.id) ? 'Unfavorite' : 'Add to Favorites'),
              onPressed: () => fav.toggle(restaurant!),
            ),
            const SizedBox(height: 20),
            const Divider(),
            Text('Reviews', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (restaurant!.customerReviews.isEmpty) const Text('No reviews yet') else Column(
              children: restaurant!.customerReviews.map((r) => ListTile(
                title: Text(r.name),
                subtitle: Text(r.review),
                trailing: Text(r.date, style: Theme.of(context).textTheme.bodySmall),
              )).toList(),
            ),
            const SizedBox(height: 16),
            const Divider(),
            Text('Add a review', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Your name')),
            const SizedBox(height: 8),
            TextField(controller: _reviewCtrl, decoration: const InputDecoration(labelText: 'Your review'), maxLines: 3),
            const SizedBox(height: 12),
            submitting ? const Center(child: CircularProgressIndicator()) : SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _submit, child: const Text('Submit Review')),
            ),
          ],
        ),
      )),
    );
  }
}
