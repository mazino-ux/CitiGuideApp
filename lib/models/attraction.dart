class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}


class Attraction {
  final String id;
  final String cityId;
  final String name;
  final String? description;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final double? rating;
  final double? price;
  final bool isFeatured;
  final String categoryId;
  final String category;
  final DateTime createdAt;
  final List<String> images;

  Attraction({
    required this.id,
    required this.cityId,
    required this.name,
    this.description,
    this.location,
    this.latitude,
    this.longitude,
    this.imageUrl,
    this.rating,
    this.price,
    this.isFeatured = false,
    required this.categoryId,
    required this.category,
    required this.createdAt,
    this.images = const [],
  });

  factory Attraction.fromMap(Map<String, dynamic> map) {
    return Attraction(
      id: map['id'] ?? '',
      cityId: map['city_id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      location: map['location'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      imageUrl: map['image_url'],
      rating: map['rating']?.toDouble(),
      price: map['price']?.toDouble(),
      isFeatured: map['is_featured'] ?? false,
      categoryId: map['category_id'] ?? '',
      category: map['category'] ?? 'General',
      createdAt: DateTime.parse(map['created_at']),
      images: List<String>.from(map['images'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city_id': cityId,
      'name': name,
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
      'rating': rating,
      'price': price,
      'is_featured': isFeatured,
      'category_id': categoryId,
      'category': category,
      'created_at': createdAt.toIso8601String(),
      'images': images,
    };
  }
}