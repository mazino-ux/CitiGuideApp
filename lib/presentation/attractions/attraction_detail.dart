import 'package:flutter/material.dart';
import 'package:citi_guide_app/widgets/review_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttractionDetail extends StatefulWidget {
  final String attractionId;

  const AttractionDetail({
    super.key,
    required this.attractionId,
  });

  @override
  _AttractionDetailState createState() => _AttractionDetailState();
}

class _AttractionDetailState extends State<AttractionDetail> {
  final _supabase = Supabase.instance.client;
  final TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 0;
  Map<String, dynamic>? _attraction;
  bool _isLoading = true;
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchAttractionDetails();
    _fetchReviews();
  }

  Future<void> _fetchAttractionDetails() async {
    try {
      final response = await _supabase
          .from('attractions')
          .select('*')
          .eq('id', widget.attractionId)
          .single();

      setState(() {
        _attraction = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load attraction details: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _fetchReviews() async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('*')
          .eq('attraction_id', widget.attractionId)
          .order('created_at', ascending: false);

      setState(() {
        _reviews = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load reviews: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.isEmpty || _selectedRating == 0) return;

    try {
      final userId = _supabase.auth.currentUser?.id ?? 'anonymous';
      
      await _supabase.from('reviews').insert({
        'attraction_id': widget.attractionId,
        'user_id': userId,
        'comment': _reviewController.text,
        'rating': _selectedRating,
      });

      _reviewController.clear();
      _selectedRating = 0;
      await _fetchReviews(); // Refresh reviews after submission
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit review: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_attraction?['name'] ?? 'Loading...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Image
                  SizedBox(
                    height: 200,
                    child: _attraction?['image_url'] != null
                        ? Image.network(
                            _attraction!['image_url'],
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.photo, size: 100),
                          ),
                  ),
                  // Attraction Details
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _attraction?['name'] ?? 'Unnamed Attraction',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(5, (index) {
                            final rating = (_attraction?['rating'] as num?)?.toDouble() ?? 0.0;
                            return Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: Theme.of(context).colorScheme.secondary,
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
                        Text(
                          _attraction?['description'] ?? 'No description available',
                          style: const TextStyle(fontSize: 16),
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
                        Text(
                          _attraction?['location'] ?? 'Location not specified',
                          style: const TextStyle(fontSize: 16),
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
                            userName: review['user_id'] ?? 'Anonymous',
                            comment: review['comment'] ?? '',
                            rating: (review['rating'] as num?)?.toInt() ?? 0,
                            timestamp: review['created_at'] != null
                                ? DateTime.parse(review['created_at'])
                                : DateTime.now(),
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
                                color: Theme.of(context).colorScheme.secondary,
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