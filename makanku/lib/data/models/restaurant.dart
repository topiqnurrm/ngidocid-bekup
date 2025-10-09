
class MenuItem {
  final String name;
  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(name: json['name'] ?? '');
  Map<String, dynamic> toJson() => {'name': name};
}

class Menus {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods: (json['foods'] as List? ?? []).map((e) => MenuItem.fromJson(Map<String, dynamic>.from(e))).toList(),
        drinks: (json['drinks'] as List? ?? []).map((e) => MenuItem.fromJson(Map<String, dynamic>.from(e))).toList(),
      );

  Map<String, dynamic> toJson() => {
        'foods': foods.map((e) => e.toJson()).toList(),
        'drinks': drinks.map((e) => e.toJson()).toList(),
      };
}

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
  final Menus menus;
  final List<Review> customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.rating,
    required this.pictureId,
    required this.menus,
    required this.customerReviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final menuJson = json['menus'] ?? json['menu'] ?? {};
    return Restaurant(
      id: json['id'] ?? json['restaurantId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      rating: (json['rating'] is int) ? (json['rating'] as int).toDouble() : (json['rating'] is double ? json['rating'] : double.tryParse('${json['rating']}') ?? 0.0),
      pictureId: json['pictureId'] ?? json['imageId'] ?? '',
      menus: Menus.fromJson(menuJson is Map ? Map<String, dynamic>.from(menuJson) : {}),
      customerReviews: (json['customerReviews'] as List? ?? []).map((e) => Review.fromJson(Map<String, dynamic>.from(e))).toList(),
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
        'menus': menus.toJson(),
        'customerReviews': customerReviews.map((e) => e.toJson()).toList(),
      };
}
