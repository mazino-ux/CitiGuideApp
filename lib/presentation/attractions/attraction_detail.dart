import 'package:flutter/material.dart';
import 'package:citi_guide_app/widgets/review_card.dart';
import 'package:citi_guide_app/core/theme/app_theme.dart';

class AttractionDetail extends StatefulWidget {
  final String name;
  final String image;
  final double rating;

  const AttractionDetail({
    super.key,
    required this.name,
    required this.image,
    required this.rating,
  });

  @override
  _AttractionDetailState createState() => _AttractionDetailState();
}

class _AttractionDetailState extends State<AttractionDetail> {
  final TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 0;
  final List<Map<String, dynamic>> _reviews = [];

  void _submitReview() {
    if (_reviewController.text.isNotEmpty && _selectedRating > 0) {
      setState(() {
        _reviews.add({
          'user': 'User123',
          'comment': _reviewController.text,
          'rating': _selectedRating,
          'date': DateTime.now(),
        });
        _reviewController.clear();
        _selectedRating = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Carousel
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: 3, // Number of images
                itemBuilder: (context, index) {
                  return Image.asset(widget.image, fit: BoxFit.cover);
                },
              ),
            ),
            // Attraction Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < widget.rating ? Icons.star : Icons.star_border,
                        color: AppTheme.accentColor,
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The Eiffel Tower is a wrought-iron lattice tower on the Champ de Mars in Paris, France. It is named after the engineer Gustave Eiffel, whose company designed and built the tower.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Map Widget (Placeholder)
                  Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Map goes here')),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._reviews.map((review) {
                    return ReviewCard(
                      userName: review['user'],
                      comment: review['comment'],
                      rating: review['rating'],
                      timestamp: review['date'],
                    );
                  }),
                  const SizedBox(height: 16),
                  const Text(
                    'Leave a Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      hintText: 'Write your review...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _selectedRating ? Icons.star : Icons.star_border,
                          color: AppTheme.accentColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: const Text('Submit Review'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}