class Attraction {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String category;
  final double distance;
  final List<Review> reviews;

  Attraction({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.category,
    required this.distance,
    required this.reviews,
  });

  factory Attraction.fromMap(Map<String, dynamic> map) {
    return Attraction(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['image_url'] as String,
      rating: (map['rating'] as num).toDouble(),
      category: map['category'] as String,
      distance: (map['distance'] as num).toDouble(),
      reviews: (map['reviews'] as List<dynamic>?)
          ?.map((r) => Review.fromMap(r))
          .toList() ?? [],
    );
  }
}

class Review {
  final String id;
  final int rating;
  final String comment;
  final String userName;
  final String? userAvatar;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.userName,
    this.userAvatar,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as String,
      rating: map['rating'] as int,
      comment: map['comment'] as String,
      userName: (map['user'] as Map<String, dynamic>)['name'] as String,
      userAvatar: (map['user'] as Map<String, dynamic>)['avatar_url'] as String?,
    );
  }
}