import 'package:flutter/material.dart';
import '../../../../widgets/review_card.dart';
// import 'review_card.dart'; 

class ReviewsSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final VoidCallback onReviewUpdated;
  final VoidCallback onReviewDeleted;

  const ReviewsSection({
    super.key,
    required this.reviews,
    required this.onReviewUpdated,
    required this.onReviewDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews (${reviews.length})',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (reviews.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'No reviews yet. Be the first to review!',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          )
        else
          Column(
            children: [
              ...reviews.map((review) => ReviewCard(
                    review: review,
                    onReviewUpdated: onReviewUpdated,
                    onReviewDeleted: onReviewDeleted,
                  )),
            ],
          ),
      ],
    );
  }
}