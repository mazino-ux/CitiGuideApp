import 'package:citi_guide_app/presentation/city/city_attractions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ExploreScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cities;

  const ExploreScreen({super.key, required this.cities});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Map<String, dynamic>> _cities = [];
  List<Map<String, dynamic>> _filteredCities = [];
  String _selectedCategory = 'All';
  String _citySearchQuery = '';
  bool _isLoading = false;
  Map<String, dynamic>? _selectedCity;

  final _categories = [
    {'name': 'All'},
    {'name': 'Popular'},
    {'name': 'Featured'},
  ];

  @override
  void initState() {
    super.initState();
    _cities = widget.cities;
    _filteredCities = List.from(_cities);
  }

  void _filterCitySection() {
    setState(() {
      _filteredCities = _cities.where((city) {
        final matchesSearch = city['name']
            .toString()
            .toLowerCase()
            .contains(_citySearchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' ||
            (_selectedCategory == 'Popular' && (city['isPopular'] == true)) ||
            (_selectedCategory == 'Featured' && (city['isFeatured'] == true));
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1200) return 4;
    if (width >= 800) return 3;
    return 2;
  }

  double _getChildAspectRatio(double width) {
    if (width >= 1200) return 0.8;
    if (width >= 800) return 1.0;
    return 1.2;
  }

  void _navigateToCityAttractions(
      BuildContext context, Map<String, dynamic> city) {
    Get.to(() => CityAttractionsScreen(city: city));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Cities'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Explore Cities',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),

              // Search
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
                  _citySearchQuery = value;
                  _filterCitySection();
                },
              ),
              SizedBox(height: 12.h),

              // Category Filter
              SizedBox(
                height: 50.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return ChoiceChip(
                      label: Text(category['name']!),
                      selected: _selectedCategory == category['name'],
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: _selectedCategory == category['name']
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      onSelected: (selected) {
                        _selectedCategory =
                            selected ? category['name']! : 'All';
                        _filterCitySection();
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),

              // City Grid
              _filteredCities.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Icon(Icons.location_city,
                              size: 60.w, color: Colors.grey[400]),
                          SizedBox(height: 16.h),
                          Text(
                            'No cities found',
                            style: TextStyle(
                                fontSize: 18.sp, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredCities.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _getCrossAxisCount(screenWidth),
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: _getChildAspectRatio(screenWidth),
                      ),
                      itemBuilder: (context, index) {
                        final city = _filteredCities[index];
                        return GestureDetector(
                          onTap: () =>
                              _navigateToCityAttractions(context, city),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    city['image_url'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withAlpha(128),
                                        Colors.transparent
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10.h,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5.h,
                                        horizontal: 8.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(135),
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                      ),
                                      child: Text(
                                        city['name'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
