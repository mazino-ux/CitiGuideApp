import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:citi_guide_app/core/services/attraction_service.dart';
import 'package:citi_guide_app/models/attraction.dart';

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
  final List<String> _categories = ['All', 'Landmark', 'Museum', 'Park', 'Restaurant'];
  final List<String> _sortOptions = ['Rating', 'Recent', 'Name'];

  @override
  void initState() {
    super.initState();
    _fetchAttractions();
  }

  Future<void> _fetchAttractions() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final attractions = await _attractionService.getAttractionsByCity(widget.city['id']);
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
    // Filter by search query and category
    List<Attraction> filtered = _attractions.where((attraction) {
      final matchesSearch = attraction.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || attraction.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    // Sort the results
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
    // final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(160),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 20.w),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // City Header Image
          SliverAppBar(
            expandedHeight: 250.h,
            flexibleSpace: FlexibleSpaceBar(
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
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
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
                    Icon(Icons.error_outline, size: 48.w, color: Colors.red[300]),
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
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final attraction = _filteredAttractions[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: AttractionCard(attraction: attraction),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _filteredAttractions.length,
                ),
              ),
            ),
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
    final theme = Theme.of(context);
    final firstImage = attraction.images.isNotEmpty ? attraction.images[0] : attraction.imageUrl ?? '';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: theme.colorScheme.outline.withAlpha(80),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          // Handle attraction tap
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Attraction Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: firstImage,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported),
                ),
              ),
            ),

            // Attraction Info
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (attraction.isFeatured)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'FEATURED',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      if (attraction.isFeatured) SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          attraction.category,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    attraction.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.solidStar,
                        size: 16.w,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        (attraction.rating?.toStringAsFixed(1) ?? '0.0'),
                        style: theme.textTheme.bodyMedium,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        attraction.price != null ? '\$${attraction.price!.toStringAsFixed(2)}' : 'Free',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    attraction.description ?? '',
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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