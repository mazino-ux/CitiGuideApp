import 'package:citi_guide_app/presentation/attractions/attraction_detail/attraction_detail.dart';
import 'package:citi_guide_app/widgets/attraction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
          .select(
              '''id, name, image_url, rating, category, location, latitude, longitude, description, is_featured''')
          .eq('is_featured', true)
          .order('rating', ascending: false)
          .limit(6);

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
          SnackBar(
            content: Text('Failed to load attractions: $e'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _navigateToDetail(BuildContext context, String attractionId) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            AttractionDetail(attractionId: attractionId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1100;
    final bool isDesktop = screenWidth >= 1100;
    final double scaleFactor = isMobile ? 1.0 : (isTablet ? 0.8 : 0.5);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w * scaleFactor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '✨ Top Attractions',
                style: TextStyle(
                  fontSize: isDesktop
                      ? 8.sp
                      : isTablet
                          ? 12.sp
                          : 20.0.sp * scaleFactor,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh,
                    size: isDesktop
                        ? 10.sp
                        : isTablet
                            ? 12.sp
                            : 24.0.sp * scaleFactor),
                onPressed: _fetchFeaturedAttractions,
              ),
            ],
          ),
          SizedBox(height: 8.0.h * scaleFactor),
          Text(
            'Discover the most loved places in the city',
            style: TextStyle(
              fontSize: isDesktop
                  ? 6.sp
                  : isTablet
                      ? 10.sp
                      : 14.0.sp * scaleFactor,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
            ),
          ),
          SizedBox(
              height: isDesktop
                  ? 12.h
                  : isTablet
                      ? 15.h
                      : 20.0.h * scaleFactor),
          _buildAttractionsGrid(scaleFactor, isDesktop, isTablet),
        ],
      ),
    );
  }

  Widget _buildAttractionsGrid(
      double scaleFactor, bool isDesktop, bool isTablet) {
    if (_isLoading) {
      return SizedBox(
        height: isDesktop ? 150.h : 250.h * scaleFactor,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    }

    if (_hasError) {
      return Container(
        height: isDesktop ? 100.h : 200.h * scaleFactor,
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: isDesktop ? 20.sp : 40.sp * scaleFactor,
                color: Colors.red[300]),
            SizedBox(height: 16.0.h * scaleFactor),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: isDesktop
                    ? 8.sp
                    : isTablet
                        ? 12.sp
                        : 16.0.sp * scaleFactor,
                color: Colors.red[700],
              ),
            ),
            SizedBox(height: 16.0.h * scaleFactor),
            ElevatedButton(
              onPressed: _fetchFeaturedAttractions,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[100],
                foregroundColor: Colors.red[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: isDesktop
                        ? 12.w
                        : isTablet
                            ? 15.w
                            : 24.0.w * scaleFactor,
                    vertical: isDesktop
                        ? 8.h
                        : isTablet
                            ? 10.h
                            : 12.0.h * scaleFactor),
              ),
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_attractions.isEmpty) {
      return Container(
        height: isDesktop ? 100.h : 200.h * scaleFactor,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off,
                size: isDesktop
                    ? 20.sp
                    : isTablet
                        ? 30.sp
                        : 40.0.sp * scaleFactor,
                color: Colors.grey[400]),
            SizedBox(height: 16.0 * scaleFactor),
            Text(
              'No attractions found',
              style: TextStyle(
                fontSize: isDesktop
                    ? 8.sp
                    : isTablet
                        ? 12.sp
                        : 16.0 * scaleFactor,
                color: Colors.grey[600],
              ),
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
          crossAxisCount: isDesktop
              ? 4
              : isTablet
                  ? 3
                  : 2,
          crossAxisSpacing: 16.0 * scaleFactor,
          mainAxisSpacing: 16.0 * scaleFactor,
          childAspectRatio: 0.75,
        ),
        itemCount: _attractions.length,
        itemBuilder: (context, index) {
          final attraction = _attractions[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 500),
            columnCount: isDesktop
                ? 4
                : isTablet
                    ? 3
                    : 2,
            child: ScaleAnimation(
              scale: 0.5,
              child: FadeInAnimation(
                child: AttractionCard(
                  attraction: attraction,
                  onTap: () =>
                      _navigateToDetail(context, attraction['id'].toString()),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
