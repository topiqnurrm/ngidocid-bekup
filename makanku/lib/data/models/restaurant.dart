class Review {
  final String name;
  final String review;
  final String date;

  Review({required this.name, required this.review, required this.date});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    name: json['name'] ?? '',
    review: json['review'] ?? '',
    date: json['date'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'review': review,
    'date': date,
  };
}

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final double rating;
  final String pictureId;
  final List<Review> customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.rating,
    required this.pictureId,
    required this.customerReviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final reviews = (json['customerReviews'] as List?) ?? [];
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      rating: (json['rating'] is int) ? (json['rating'] as int).toDouble() : (json['rating'] as num?)?.toDouble() ?? 0.0,
      pictureId: json['pictureId'] ?? '',
      customerReviews: reviews.map((e) => Review.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'city': city,
        'address': address,
        'rating': rating,
        'pictureId': pictureId,
        'customerReviews': customerReviews.map((e) => e.toJson()).toList(),
      };
}
