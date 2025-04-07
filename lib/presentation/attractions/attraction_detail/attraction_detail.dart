import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/about_section.dart';
import 'widgets/contact_section.dart';
import 'widgets/gallery_section.dart';
import 'widgets/header_section.dart';
import 'widgets/info_chips.dart';
import 'widgets/location_map.dart';
// import 'widgets/review_card.dart';
import 'widgets/review_form.dart';
import 'widgets/reviews_section.dart';

class AttractionDetail extends StatefulWidget {
  final String attractionId;

  const AttractionDetail({super.key, required this.attractionId});

  @override
  State<AttractionDetail> createState() => _AttractionDetailState();
}

class _AttractionDetailState extends State<AttractionDetail> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  Map<String, dynamic>? _attraction;
  List<String> _images = [];
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final [attraction, images, reviews] = await Future.wait([
        _fetchAttraction(),
        _fetchImages(),
        _fetchReviews(),
      ]);

      if (mounted) {
        setState(() {
          _attraction = attraction as Map<String, dynamic>?;
          _images = (images as List).cast<String>();
          _reviews = (reviews as List).cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading attraction: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<Map<String, dynamic>> _fetchAttraction() async {
    return await _supabase
        .from('attractions')
        .select('''
          *,
          cities:city_id(name)
        ''')
        .eq('id', widget.attractionId)
        .single();
  }

  Future<List<String>> _fetchImages() async {
    final imageList = await _supabase.storage
        .from('attractions')
        .list(path: 'attractions/${widget.attractionId}');

    return imageList
        .map((file) => _supabase.storage
            .from('attractions')
            .getPublicUrl('attractions/${widget.attractionId}/${file.name}'))
        .toList();
  }

  Future<List<Map<String, dynamic>>> _fetchReviews() async {
    final response = await _supabase
        .from('reviews')
        .select('''
          *,
          profiles:user_id(username, avatar_url)
        ''')
        .eq('attraction_id', widget.attractionId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _buildLoadingState();
    if (_attraction == null) return _buildErrorState();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          HeaderSection(
            attraction: _attraction!,
            primaryImage: _images.isNotEmpty ? _images.first : _attraction!['image_url'],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Gallery Section
                GallerySection(images: _images),
                const SizedBox(height: 24),

                // Info Chips
                InfoChips(
                  category: _attraction!['category'],
                  openingHours: _attraction!['opening_hours'],
                  isFeatured: _attraction!['is_featured'] ?? false,
                ),
                const SizedBox(height: 24),

                // About Section
                AboutSection(description: _attraction!['description']),
                const SizedBox(height: 24),

                // Location Map
                LocationMap(
                  location: _attraction!['location'],
                  latitude: _attraction!['latitude'],
                  longitude: _attraction!['longitude'],
                ),
                const SizedBox(height: 24),

                // Contact Section
                ContactSection(
                  website: _attraction!['website'],
                  phone: _attraction!['phone'],
                ),
                const SizedBox(height: 24),

                // Reviews Section
                ReviewsSection(
                  reviews: _reviews,
                  onReviewUpdated: _fetchData, // Refresh when review is updated
                  onReviewDeleted: _fetchData, // Refresh when review is deleted
                ),

                // Keep the ReviewForm as is
                ReviewForm(
                  attractionId: widget.attractionId,
                  onReviewSubmitted: _fetchData,
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading attraction details...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(258),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load attraction',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchData,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}