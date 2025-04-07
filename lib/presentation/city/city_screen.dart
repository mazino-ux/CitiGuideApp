import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

class AttractionsScreen extends StatefulWidget {
  final String cityId;
  const AttractionsScreen({super.key, required this.cityId});

  @override
  State<AttractionsScreen> createState() => _AttractionsScreenState();
}

class _AttractionsScreenState extends State<AttractionsScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _attractions = [];
  List<Map<String, dynamic>> _filteredAttractions = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Featured', 'Popular', 'Recent'];

  @override
  void initState() {
    super.initState();
    _fetchAttractions();
  }

  Future<void> _fetchAttractions() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await _supabase
          .from('attractions')
          .select('*')
          .eq('city_id', widget.cityId)
          .order('created_at', ascending: false);

      setState(() {
        _attractions = List<Map<String, dynamic>>.from(response);
        _filteredAttractions = List.from(_attractions);
        _isLoading = false;
      });
    } catch (e) {
      if (e is PostgrestException && e.code == '403') {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading attractions: ${e.toString()}')),
        );
      }
    }
  }

  void _filterAttractions() {
    setState(() {
      _filteredAttractions = _attractions.where((attraction) {
        final matchesSearch = attraction['name']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
        
        final matchesFilter = _selectedFilter == 'All' ||
            (_selectedFilter == 'Featured' && attraction['is_featured'] == true) ||
            (_selectedFilter == 'Popular' && ((attraction['rating'] as num?)?.toDouble() ?? 0) >= 4.0) ||
            (_selectedFilter == 'Recent' && _isRecent(attraction));
        
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  bool _isRecent(Map<String, dynamic> attraction) {
    final createdAt = DateTime.parse(attraction['created_at']);
    return createdAt.isAfter(DateTime.now().subtract(const Duration(days: 30)));
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final crossAxisCount = isMobile ? 2 : (MediaQuery.of(context).size.width ~/ 300).clamp(4, 5);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: _isLoading
          ? Center(
              child: Lottie.asset(
                'assets/lottie/loading.json',
                width: 200.w,
                height: 200.h,
              ),
            )
          : Column(
              children: [
                // Search and Filter Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    children: [
                      // Search Bar
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search attractions...',
                          prefixIcon: Icon(Icons.search, color: colorScheme.onSurface.withAlpha(150)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHigh,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                            _filterAttractions();
                          });
                        },
                      ),
                      SizedBox(height: 12.h),
                      // Filter Chips
                      SizedBox(
                        height: 50.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filters.length,
                          separatorBuilder: (_, __) => SizedBox(width: 8.w),
                          itemBuilder: (context, index) {
                            final filter = _filters[index];
                            return ChoiceChip(
                              label: Text(filter),
                              selected: _selectedFilter == filter,
                              selectedColor: colorScheme.primary,
                              labelStyle: TextStyle(
                                color: _selectedFilter == filter
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurface.withAlpha(200),
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilter = selected ? filter : 'All';
                                  _filterAttractions();
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Attractions Grid
                Expanded(
                  child: _filteredAttractions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.attractions,
                                size: 60.w,
                                color: colorScheme.onSurface.withAlpha(100),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No attractions found',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(150),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16.w,
                              mainAxisSpacing: 16.h,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: _filteredAttractions.length,
                            itemBuilder: (context, index) {
                              final attraction = _filteredAttractions[index];
                              return _AttractionCard(
                                attraction: attraction,
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class _AttractionCard extends StatelessWidget {
  final Map<String, dynamic> attraction;

  const _AttractionCard({
    required this.attraction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navigate to attraction detail
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Attraction Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: attraction['image_url'] != null
                    ? CachedNetworkImage(
                        imageUrl: attraction['image_url'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: colorScheme.surfaceContainerHigh,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: colorScheme.surfaceContainerHigh,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              color: colorScheme.onSurface.withAlpha(100),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: colorScheme.surfaceContainerHigh,
                        child: Center(
                          child: Icon(
                            Icons.attractions,
                            size: 48.w,
                            color: colorScheme.onSurface.withAlpha(100),
                          ),
                        ),
                      ),
              ),
            ),
            // Attraction Info
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attraction['name'] ?? 'Unnamed Attraction',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16.w,
                        color: colorScheme.onSurface.withAlpha(150),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          attraction['location'] ?? 'Unknown location',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withAlpha(150),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16.w,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        (attraction['rating'] as num?)?.toStringAsFixed(1) ?? '0.0',
                        style: theme.textTheme.bodySmall,
                      ),
                      const Spacer(),
                      if (attraction['is_featured'] == true)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Featured',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
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