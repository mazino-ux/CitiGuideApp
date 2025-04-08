// attraction.dart
class Attraction {
  final String id;
  final String cityId;
  final String name;
  final String? description;
  final String? location;
  final String? imageUrl;
  final double? rating;
  final double? price;
  final bool isFeatured;
  final String category;
  final DateTime createdAt;
  final List<String> images;

  Attraction({
    required this.id,
    required this.cityId,
    required this.name,
    this.description,
    this.location,
    this.imageUrl,
    this.rating,
    this.price,
    this.isFeatured = false,
    this.category = 'General',
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
      imageUrl: map['image_url'],
      rating: map['rating']?.toDouble(),
      price: map['price']?.toDouble(),
      isFeatured: map['is_featured'] ?? false,
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
      'image_url': imageUrl,
      'rating': rating,
      'price': price,
      'is_featured': isFeatured,
      'category': category,
      'created_at': createdAt.toIso8601String(),
      'images': images,
    };
  }
}