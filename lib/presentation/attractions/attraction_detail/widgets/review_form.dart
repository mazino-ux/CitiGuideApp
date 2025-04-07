import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewForm extends StatefulWidget {
  final String attractionId;
  final VoidCallback onReviewSubmitted;

  const ReviewForm({
    super.key,
    required this.attractionId,
    required this.onReviewSubmitted,
  });

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _supabase = Supabase.instance.client;
  final _reviewController = TextEditingController();
  double _selectedRating = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.isEmpty || _selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide both rating and review text')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      await _supabase.from('reviews').insert({
        'attraction_id': widget.attractionId,
        'user_id': userId,
        'comment': _reviewController.text,
        'rating': _selectedRating,
      });

      _reviewController.clear();
      _selectedRating = 0;
      widget.onReviewSubmitted();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share Your Experience',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _reviewController,
          decoration: InputDecoration(
            hintText: 'What did you think of this place?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          maxLines: 4,
        ),
        const SizedBox(height: 16),
        Center(
          child: RatingBar.builder(
            initialRating: _selectedRating,
            minRating: 1,
            itemCount: 5,
            itemSize: 32,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) => setState(() => _selectedRating = rating),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitReview,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isSubmitting
                ? const CircularProgressIndicator()
                : const Text('Submit Review'),
          ),
        ),
      ],
    );
  }
}