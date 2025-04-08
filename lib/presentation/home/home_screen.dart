import 'package:citi_guide_app/core/services/city_service.dart';
import 'package:citi_guide_app/models/city.dart';
import 'package:citi_guide_app/presentation/city/city_attractions_screen.dart';
import 'package:citi_guide_app/presentation/home/widgets/faq_widget.dart';
import 'package:citi_guide_app/presentation/home/widgets/navbar/navbar.dart';
import 'package:citi_guide_app/presentation/home/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'widgets/hero_section.dart';
import 'widgets/featured_attractions.dart';
import 'widgets/footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CityService _cityService = CityService();
  bool _isLoading = true;
  bool _hasError = false;
  List<City> _cities = [];
  List<City> _filteredCities = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Recent']; // Simplified categories
  City? _selectedCity;
  bool isAdmin = true;

  @override
  void initState() {
    super.initState();
    _fetchCities();
  }

  Future<void> _fetchCities() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final cities = await _cityService.getCities();
      setState(() {
        _cities = cities;
        _filteredCities = cities;
        _selectedCity = cities.isNotEmpty ? cities[0] : null;
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
            content: Text('Failed to load cities: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterCities() {
    setState(() { 
      _filteredCities = _cities.where((city) {
        final matchesSearch = city.name
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' ||
            (_selectedCategory == 'Recent' && _isRecent(city));
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  bool _isRecent(City city) {
    return city.createdAt.isAfter(
      DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  void _onCitySelected(City city) {
    setState(() {
      _selectedCity = city;
    });
  }

  void _navigateToCityAttractions(City city) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CityAttractionsScreen(city: city.toMap()),
      ),
    );
  }

  Future<void> _openSearch() async {
    final result = await showSearch<String>(
      context: context,
      delegate: HomeSearchBar(
        cities: _cities
            .map((city) => {'name': city.name, 'image': city.imageUrl ?? ''})
            .toList(),
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _searchQuery = result;
        _filterCities();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final crossAxisCount = isMobile ? 2 : (MediaQuery.of(context).size.width ~/ 300).clamp(4, 5);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: GestureDetector(
          onTap: _openSearch,
          child: Navbar(
            isAdmin: isAdmin,
            cities: _cities.map((city) => city.toMap()).toList(),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Lottie.asset(
                'assets/lottie/loading.json',
                width: 200.w,
                height: 200.h,
              ),
            )
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60.w, color: Colors.red[300]),
                      SizedBox(height: 16.h),
                      Text(
                        'Failed to load cities',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.red[700],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: _fetchCities,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[100],
                          foregroundColor: Colors.red[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_selectedCity != null)
                      HeroSection(
                        city: _selectedCity?.name ?? '',
                        image: _selectedCity?.imageUrl ?? '',
                        description: _selectedCity?.description ?? '',
                        cities: _cities, // Now passing List<City> directly
                        onCitySelected: (city) {
                          _onCitySelected(city);
                        },
                      ),
                      SizedBox(height: 20.h),
                      
                      // Cities Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Explore Cities',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            
                            // Search and Filter Bar
                            Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search cities...',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                      _filterCities();
                                    });
                                  },
                                ),
                                SizedBox(height: 12.h),
                                
                                // Category Filter Chips
                                SizedBox(
                                  height: 50.h,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _categories.length,
                                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                                    itemBuilder: (context, index) {
                                      final category = _categories[index];
                                      return ChoiceChip(
                                        label: Text(category),
                                        selected: _selectedCategory == category,
                                        selectedColor: Theme.of(context).colorScheme.primary,
                                        labelStyle: TextStyle(
                                          color: _selectedCategory == category
                                              ? Colors.white
                                              : Theme.of(context).colorScheme.onSurface,
                                        ),
                                        onSelected: (selected) {
                                          setState(() {
                                            _selectedCategory = selected ? category : 'All';
                                            _filterCities();
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            
                            // City Cards Grid
                            _filteredCities.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_city,
                                          size: 60.w,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(height: 16.h),
                                        Text(
                                          'No cities found',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : AnimationLimiter(
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 16.w,
                                        mainAxisSpacing: 16.h,
                                        childAspectRatio: 0.8,
                                      ),
                                      itemCount: _filteredCities.length,
                                      itemBuilder: (context, index) {
                                        final city = _filteredCities[index];
                                        return AnimationConfiguration.staggeredGrid(
                                          position: index,
                                          duration: const Duration(milliseconds: 500),
                                          columnCount: crossAxisCount,
                                          child: ScaleAnimation(
                                            child: FadeInAnimation(
                                              child: _CityCard(
                                                city: city,
                                                onTap: () => _navigateToCityAttractions(city),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      
                      FeaturedAttractions(),
                      SizedBox(height: 20.h),
                      const FAQWidget(),
                      SizedBox(height: 20.h),
                      Footer(),
                    ],
                  ),
                ),
    );
  }
}

class _CityCard extends StatelessWidget {
  final City city;
  final VoidCallback onTap;

  const _CityCard({
    required this.city,
    required this.onTap,
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
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // City Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: city.imageUrl ?? '', // Handle null imageUrl
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
            ),
            // City Info
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    city.description ?? 'No description available',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withAlpha(180),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16.w,
                        color: colorScheme.onSurface.withAlpha(180),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Added ${_formatDate(city.createdAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withAlpha(180),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'just now';
    }
  }
}