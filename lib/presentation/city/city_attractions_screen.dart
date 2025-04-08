import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:citi_guide_app/core/services/attraction_service.dart';
import 'package:citi_guide_app/models/attraction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CityAttractionsScreen extends StatefulWidget {
  final Map<String, dynamic> city;
  const CityAttractionsScreen({super.key, required this.city});

  @override
  State<CityAttractionsScreen> createState() => _CityAttractionsScreenState();
}

class _CityAttractionsScreenState extends State<CityAttractionsScreen> {
  final AttractionService _attractionService = AttractionService();
  List<Attraction> _attractions = [];
  List<Attraction> _filteredAttractions = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedSort = 'Rating';
  final _supabase = Supabase.instance.client;
  List<String> _categories = [];
  final List<String> _sortOptions = ['Rating', 'Recent', 'Name'];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchAttractions();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Fetch from Supabase
      final response = await _supabase.from('categories').select('*');
      // This gives us a List<dynamic> of dynamic maps
      final rawCategories = List<Map<String, dynamic>>.from(response);

      if (mounted) {
        setState(() {
          _categories = ['All'] +
              rawCategories.map((cat) => cat['name'].toString()).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load categories: $e'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _fetchAttractions() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final attractions =
          await _attractionService.getAttractionsByCity(widget.city['id']);
      setState(() {
        _attractions = attractions;
        _filteredAttractions = attractions;
        _isLoading = false;
        _filterAndSortAttractions();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load attractions: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterAndSortAttractions() {
    List<Attraction> filtered = _attractions.where((attraction) {
      final matchesSearch =
          attraction.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' ||
          attraction.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    filtered.sort((a, b) {
      switch (_selectedSort) {
        case 'Rating':
          return (b.rating ?? 0).compareTo(a.rating ?? 0);
        case 'Recent':
          return b.createdAt.compareTo(a.createdAt);
        case 'Name':
          return a.name.compareTo(b.name);
        default:
          return 0;
      }
    });

    setState(() {
      _filteredAttractions = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1100;
    final bool isDesktop = screenWidth >= 1100;

    final double factor = isMobile ? 1.0 : (isTablet ? 0.8 : 0.65);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: isDesktop ? 270.h : 250.h * factor,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                margin: EdgeInsets.only(
                  top: 7.h,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 6.h,
                  horizontal: 10.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(180),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  "Explore / ${widget.city['name']}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop ? 5.sp : 16.sp * factor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              background: CachedNetworkImage(
                imageUrl: widget.city['image_url'] ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),

          // City Info Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.city['name'],
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.locationDot,
                        size: 16.w,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        widget.city['location'] ?? 'Unknown location',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(210),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    widget.city['description'] ?? '',
                    style: theme.textTheme.bodyLarge,
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // Filter and Search Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search attractions...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _filterAndSortAttractions();
                      });
                    },
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          items: _categories.map((String catName) {
                            return DropdownMenuItem<String>(
                              value: catName,
                              child: Text(catName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                              _filterAndSortAttractions();
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedSort,
                          items: _sortOptions.map((option) {
                            return DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSort = value!;
                              _filterAndSortAttractions();
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Sort by',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),

          // Attractions Section Header
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Attractions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_filteredAttractions.length} places',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(180),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Attractions List
          if (_isLoading)
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_hasError)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 48.w, color: Colors.red[300]),
                    SizedBox(height: 16.h),
                    Text(
                      'Failed to load attractions',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.red[700],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: _fetchAttractions,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            )
          else if (_filteredAttractions.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 60.w,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No attractions found',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(2.w, 2.h, 2.w, 2.h),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final attraction = _filteredAttractions[index];
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: isDesktop
                          ? 4
                          : isTablet
                              ? 3
                              : 2,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: AttractionCard(attraction: attraction),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _filteredAttractions.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop
                      ? 4
                      : isTablet
                          ? 3
                          : 2,
                  crossAxisSpacing: 16.0 * factor,
                  mainAxisSpacing: 16.0 * factor,
                  childAspectRatio: 0.75,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class AttractionCard extends StatelessWidget {
  final Attraction attraction;

  const AttractionCard({super.key, required this.attraction});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1100;
    final bool isDesktop = screenWidth >= 1100;

    final firstImage = attraction.images.isNotEmpty
        ? attraction.images[0]
        : attraction.imageUrl ?? '';
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isDesktop ? 10.r : 14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isDesktop ? 10.r : 14.r),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: firstImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary.withAlpha(128),
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(178),
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 6.w : 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        attraction.name,
                        style: TextStyle(
                          fontSize: isDesktop
                              ? 7.sp
                              : isTablet
                                  ? 10.sp
                                  : 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 4.h),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: isDesktop
                                ? 5.sp
                                : isTablet
                                    ? 10.sp
                                    : 14.sp,
                            color: Colors.white.withAlpha(204),
                          ),
                          SizedBox(width: isDesktop ? 2.w : 4.w),
                          Expanded(
                            child: Text(
                              attraction.location!,
                              style: TextStyle(
                                fontSize: isDesktop
                                    ? 5.sp
                                    : isTablet
                                        ? 8.sp
                                        : 12.sp,
                                color: Colors.white.withAlpha(204),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                          height: isDesktop
                              ? 3.h
                              : isTablet
                                  ? 5.h
                                  : 8.h),

                      // Rating and Category
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Rating
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop
                                  ? 3.w
                                  : isTablet
                                      ? 5.w
                                      : 8.w,
                              vertical: isDesktop
                                  ? 2.h
                                  : isTablet
                                      ? 3.h
                                      : 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: isDesktop
                                      ? 6.sp
                                      : isTablet
                                          ? 10.sp
                                          : 14.sp,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  (attraction.rating?.toStringAsFixed(1) ??
                                      '0.0'),
                                  style: TextStyle(
                                    fontSize: isDesktop
                                        ? 5.sp
                                        : isTablet
                                            ? 8.sp
                                            : 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Category
                          if (attraction.category != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop
                                    ? 3.w
                                    : isTablet
                                        ? 5.w
                                        : 8.w,
                                vertical: isDesktop
                                    ? 2.h
                                    : isTablet
                                        ? 3.h
                                        : 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(51),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withAlpha(76),
                                ),
                              ),
                              child: Text(
                                attraction.category,
                                style: TextStyle(
                                  fontSize: isDesktop
                                      ? 5.sp
                                      : isTablet
                                          ? 7.sp
                                          : 10.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Featured Badge
              if (attraction.isFeatured == true)
                Positioned(
                  top: 12.h,
                  left: isDesktop ? 6.w : 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop
                          ? 3.w
                          : isTablet
                              ? 5.w
                              : 8.w,
                      vertical: isDesktop
                          ? 2.h
                          : isTablet
                              ? 3.h
                              : 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'Featured',
                      style: TextStyle(
                        fontSize: isDesktop
                            ? 5.sp
                            : isTablet
                                ? 7.sp
                                : 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
