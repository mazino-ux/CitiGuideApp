import 'package:citi_guide_app/data/city_data.dart';
import 'package:citi_guide_app/presentation/home/widgets/faq_widget.dart';
import 'package:citi_guide_app/presentation/home/widgets/navbar/navbar.dart';
import 'package:citi_guide_app/presentation/home/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/hero_section.dart';
import 'widgets/featured_attractions.dart';
import 'widgets/footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _filteredCities = [];
  Map<String, dynamic>? _selectedCity;
  String _citySearchQuery = '';
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Popular', 'Featured', 'Recent'];

  @override
  void initState() {
    super.initState();

    _filteredCities = List.from(cities);
    _selectedCity = _filteredCities.isNotEmpty ? _filteredCities[0] : null;

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _filterCities(String query) {
    setState(() {
      _filteredCities = cities
          .where((city) => city['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();

      if (!_filteredCities.contains(_selectedCity)) {
        _selectedCity = _filteredCities.isNotEmpty ? _filteredCities[0] : null;
      }
    });
  }

  void _filterCitySection() {
    setState(() {
      _filteredCities = cities.where((city) {
        final matchesSearch = city['name']
            .toString()
            .toLowerCase()
            .contains(_citySearchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' ||
            (_selectedCategory == 'Popular' && (city['isPopular'] == true)) ||
            (_selectedCategory == 'Featured' && (city['isFeatured'] == true)) ||
            (_selectedCategory == 'Recent' && _isRecent(city));
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  bool _isRecent(Map<String, dynamic> city) {
    final createdAt = DateTime.parse(city['created_at']);
    return createdAt.isAfter(DateTime.now().subtract(const Duration(days: 30)));
  }

  void _onCitySelected(Map<String, dynamic> city) {
    setState(() {
      _selectedCity = city;
    });
  }

  Future<void> _openSearch() async {
    final result = await showSearch<String>(
      context: context,
      delegate: HomeSearchBar(
        cities: cities
            .map((city) =>
                city.map((key, value) => MapEntry(key, value.toString())))
            .toList(),
      ),
    );
    if (result != null && result.isNotEmpty) {
      _filterCities(result);
    }
  }

  bool isAdmin = true;

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
            cities: cities,
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
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (_selectedCity != null)
                    HeroSection(
                      city: _selectedCity!['name']!,
                      image: _selectedCity!['image']!,
                      description: _selectedCity!['description']!,
                      cities: _filteredCities,
                      onCitySelected: _onCitySelected,
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
                                  _citySearchQuery = value;
                                  _filterCitySection();
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
                                        _filterCitySection();
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
                            : GridView.builder(
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
                                  return _CityCard(
                                    city: city,
                                    onTap: () => _onCitySelected(city),
                                  );
                                },
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
  final Map<String, dynamic> city;
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
                child: Image.network(
                  city['image'],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: colorScheme.surfaceVariant,
                      child: const Center(child: Icon(Icons.broken_image)),
                    );
                  },
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
                    city['name'],
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
                        Icons.place,
                        size: 16.w,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          city['location'] ?? 'Unknown location',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
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
                        city['rating']?.toStringAsFixed(1) ?? '0.0',
                        style: theme.textTheme.bodySmall,
                      ),
                      const Spacer(),
                      if (city['isFeatured'] == true)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
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