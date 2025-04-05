import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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

  void _openFullMap(double lat, double lng) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullMapScreen(lat: lat, lng: lng),
      ),
    );
  }

@override
Widget build(BuildContext context) {
  if (_isLoading) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  final images = _attraction?['images'] as List<dynamic>? ?? [];
  final name = _attraction?['name'] ?? 'Attraction';
  final rating = (_attraction?['rating'] ?? 0).toDouble();
  final about = _attraction?['about'] ?? 'No description available';
  final lat = _attraction?['latitude'] ?? 0.0;
  final long = _attraction?['longitude'] ?? 0.0;

  return Scaffold(
    appBar: AppBar(
      title: Text(name),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          // Image Carousel
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  images[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                RatingBarIndicator(
                  rating: rating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  itemCount: 5,
                  itemSize: 24.0,
                ),
                const SizedBox(height: 16),
                const Text('About', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(about, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                const Text('Location', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                GestureDetector(
                  onDoubleTap: () => _openFullMap(lat, long),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 200,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(lat, long),
                          initialZoom: 13.0,
                          interactionOptions: const InteractionOptions(flags: 0),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(lat, long),
                                child: const Icon(Icons.location_on, color: Colors.red, size: 32),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                }).toList(),
                const SizedBox(height: 16),
                const Text('Leave a Review', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _reviewController,
                  decoration: InputDecoration(
                    hintText: 'Write your review...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 32.0,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _selectedRating = rating.toInt();
                    });
                  },
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


// Full Map View
class FullMapScreen extends StatelessWidget {
  final double lat;
  final double lng;

  const FullMapScreen({super.key, required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Explore Location")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(lat, lng),
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(lat, lng),
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
