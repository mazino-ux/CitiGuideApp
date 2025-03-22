class Review {
  final String id;
  final String userId;
  final String attractionId;
  final String comment;
  final int rating;
  final DateTime timestamp;

  Review({
    required this.id,
    required this.userId,
    required this.attractionId,
    required this.comment,
    required this.rating,
    required this.timestamp,
  });
}