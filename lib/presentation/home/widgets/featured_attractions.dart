import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:citi_guide_app/widgets/attraction_card.dart';
import 'package:citi_guide_app/presentation/attractions/attraction_detail/attraction_detail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeaturedAttractions extends StatefulWidget {
  const FeaturedAttractions({super.key});

  @override
  State<FeaturedAttractions> createState() => _FeaturedAttractionsState();
}

class _FeaturedAttractionsState extends State<FeaturedAttractions> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _attractions = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchFeaturedAttractions();
  }

  Future<void> _fetchFeaturedAttractions() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await _supabase
          .from('attractions')
          .select('''
            id, 
            name, 
            image_url, 
            rating, 
            category,
            location,
            description,
            is_featured
          ''')
          .order('rating', ascending: false)
          .limit(6); // Get 6 attractions for 3 rows

      setState(() {
        _attractions = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load attractions: $e')),
        );
      }
    }
  }

  void _navigateToDetail(BuildContext context, String attractionId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttractionDetail(
          attractionId: attractionId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Attractions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Discover the most popular places to visit',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
          SizedBox(height: 16.h),
          _buildAttractionsGrid(),
        ],
      ),
    );
  }

  Widget _buildAttractionsGrid() {
    if (_isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: const CircularProgressIndicator(),
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Icon(Icons.error_outline, size: 40.w, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              'Failed to load attractions',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _fetchFeaturedAttractions,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_attractions.isEmpty) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Icon(Icons.search_off, size: 40.w, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No attractions found',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.75,
        ),
        itemCount: _attractions.length,
        itemBuilder: (context, index) {
          final attraction = _attractions[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 500),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: AttractionCard(
                  name: attraction['name'] ?? 'Unnamed Attraction',
                  image: attraction['image_url'] ?? '',
                  rating: (attraction['rating'] as num?)?.toDouble() ?? 0.0,
                  category: attraction['category'] ?? 'Unknown',
                  location: attraction['location'] ?? 'Location not specified',
                  distance: null,
                  // isFeatured: attraction['is_featured'] ?? false,
                  onTap: () => _navigateToDetail(context, attraction['id'].toString()),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}