import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/about_section.dart';
import 'widgets/contact_section.dart';
// import 'widgets/gallery_section.dart';
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
    return await _supabase.from('attractions').select('''
          *,
          cities:city_id(name)
        ''').eq('id', widget.attractionId).single();
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
            primaryImage:
                _images.isNotEmpty ? _images.first : _attraction!['image_url'],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // // Gallery Section
                // GallerySection(images: _images),
                // const SizedBox(height: 24),


                // Info Chips
                InfoChips(
                  category: _attraction!['category'],
                  openingHours: _attraction!['opening_hours'],
                  isFeatured: _attraction!['is_featured'] ?? false,
                ),
                SizedBox(height: 24.h),

                // About Section
                AboutSection(description: _attraction!['description']),
                SizedBox(height: 24.h),

                // Location Map
                LocationMap(
                  location: _attraction!['location'],
                  latitude: _attraction!['latitude'],
                  longitude: _attraction!['longitude'],
                ),
                SizedBox(height: 24.h),

                // Contact Section
                ContactSection(
                  website: _attraction!['website'],
                  phone: _attraction!['phone'],
                ),
                SizedBox(height: 24.h),

                // Reviews Section
                ReviewsSection(
                  reviews: _reviews,
                  onReviewUpdated: _fetchData,
                  onReviewDeleted: _fetchData,
                ),

                ReviewForm(
                  attractionId: widget.attractionId,
                  onReviewSubmitted: _fetchData,
                ),
                SizedBox(height: 32.h),
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
            SizedBox(height: 16.h),
            Text(
              'Loading attraction details...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(258),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
