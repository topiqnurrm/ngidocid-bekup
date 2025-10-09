import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/restaurant.dart';
import '../../data/restaurant_repository.dart';
import '../../providers/favorite_provider.dart';

/// ---------------------------
/// DETAIL NOTIFIER
/// ---------------------------
class DetailNotifier extends ChangeNotifier {
  final String id;
  final RestaurantRepository _repo = RestaurantRepository();

  Restaurant? restaurant;
  bool loading = false;
  bool submitting = false;
  String error = '';

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController reviewCtrl = TextEditingController();

  DetailNotifier(this.id) {
    load();
  }

  /// Memuat data detail restoran dengan penanganan error yang lebih jelas
  Future<void> load() async {
    loading = true;
    error = '';
    notifyListeners();

    try {
      restaurant = await _repo
          .getDetail(id)
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw const SocketException('Timeout');
      });
    } on SocketException {
      error = 'Tidak ada koneksi internet. Periksa jaringan Anda.';
    } catch (e) {
      error = 'Gagal memuat data. Silakan coba lagi nanti.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Mengirim ulasan
  Future<bool> submitReview() async {
    final name = nameCtrl.text.trim();
    final review = reviewCtrl.text.trim();
    if (name.isEmpty || review.isEmpty) return false;

    submitting = true;
    notifyListeners();

    try {
      final ok = await _repo.addReview(id, name, review);
      if (ok) {
        nameCtrl.clear();
        reviewCtrl.clear();
        await load();
      }
      return ok;
    } catch (_) {
      return false;
    } finally {
      submitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    reviewCtrl.dispose();
    super.dispose();
  }
}

/// ---------------------------
/// DETAIL SCREEN
/// ---------------------------
class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({required this.id, super.key});

  static const _imageBase = 'https://restaurant-api.dicoding.dev/images/large/';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailNotifier(id),
      builder: (context, _) {
        final dn = Provider.of<DetailNotifier>(context);

        /// Loading state
        if (dn.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        /// Error state — tampilkan tampilan user-friendly
        if (dn.error.isNotEmpty) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 80, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(height: 16),
                    Text(
                      'Oops!',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dn.error,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Provider.of<DetailNotifier>(context, listen: false)
                            .load();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        /// Data kosong
        if (dn.restaurant == null) {
          return const Scaffold(
            body: Center(child: Text('Data tidak ditemukan')),
          );
        }

        /// Konten utama
        final r = dn.restaurant!;
        return Scaffold(
          appBar: AppBar(
            title: Text(r.name),
            actions: [
              Consumer<FavoriteProvider>(
                builder: (context, fav, __) {
                  final isFav = fav.isFavorite(r.id);
                  return IconButton(
                    icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border),
                    onPressed: () => fav.toggle(r),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((r.pictureId ?? '').isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      '$_imageBase${r.pictureId}',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 180,
                        color: Theme.of(context).dividerColor,
                        child: const Center(
                            child: Icon(Icons.broken_image, size: 50)),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(r.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),

                /// Lokasi & alamat
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.city,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            r.address,
                            softWrap: true,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${r.rating}'),
                  ],
                ),

                const SizedBox(height: 12),
                Text('Description',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(r.description),
                const SizedBox(height: 12),
                const Divider(),

                /// Menu - Foods
                Text('Menu - Foods',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if ((r.menus?.foods ?? []).isEmpty)
                  const Text('No food menu available')
                else
                  Column(
                    children: r.menus.foods
                        .map((m) => ListTile(title: Text(m.name)))
                        .toList(),
                  ),

                const SizedBox(height: 8),

                /// Menu - Drinks
                Text('Menu - Drinks',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if ((r.menus?.drinks ?? []).isEmpty)
                  const Text('No drinks menu available')
                else
                  Column(
                    children: r.menus.drinks
                        .map((m) => ListTile(title: Text(m.name)))
                        .toList(),
                  ),

                const SizedBox(height: 12),
                const Divider(),

                /// Reviews
                Text('Reviews',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if ((r.customerReviews ?? []).isEmpty)
                  const Text('No reviews yet')
                else
                  Column(
                    children: r.customerReviews
                        .map(
                          (rev) => ListTile(
                        title: Text(rev.name),
                        subtitle: Text(rev.review),
                        trailing: Text(
                          rev.date,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                        .toList(),
                  ),

                const SizedBox(height: 16),
                const Divider(),

                /// Add Review
                Text('Add a review',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: dn.nameCtrl,
                  decoration:
                  const InputDecoration(labelText: 'Your name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: dn.reviewCtrl,
                  decoration:
                  const InputDecoration(labelText: 'Your review'),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),

                dn.submitting
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final ok = await dn.submitReview();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(ok ? 'Review berhasil dikirim' : 'Gagal mengirim review'),
                        ),
                      );
                    },
                    child: const Text('Submit Review'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
