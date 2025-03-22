import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:citi_guide_app/presentation/home/widgets/search_bar.dart' as custom; // Use a prefix
import 'package:citi_guide_app/presentation/home/widgets/hero_section.dart';
import 'package:citi_guide_app/presentation/home/widgets/city_listings.dart';
import 'package:citi_guide_app/presentation/home/widgets/featured_attractions.dart';
import 'package:citi_guide_app/presentation/home/widgets/footer.dart';
import 'package:citi_guide_app/core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  final List<Map<String, String>> _cities = [
    {'name': 'New York', 'image': 'assets/images/shot_forest.jpg', 'description': 'The Big Apple'},
    {'name': 'Paris', 'image': 'assets/images/paris.jpg', 'description': 'City of Love'},
    {'name': 'Tokyo', 'image': 'assets/images/tokyo.jpg', 'description': 'Land of the Rising Sun'},
  ];
  List<Map<String, String>> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = _cities; // Initialize with all cities
    // Simulate data loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _filterCities(String query) {
    setState(() {
      _filteredCities = _cities
          .where((city) => city['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _isLoading
          ? Center(
              child: Lottie.asset(
                'assets/lottie/loading.json',
                width: 200,
                height: 200,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Search Bar
                  custom.SearchBar(
                    onChanged: _filterCities, // Pass the callback function
                  ),
                  const SizedBox(height: 20),
                  // Hero Section
                  const HeroSection(),
                  const SizedBox(height: 20),
                  // City Listings
                  CityListings(cities: _filteredCities),
                  const SizedBox(height: 20),
                  // Featured Attractions
                  const FeaturedAttractions(),
                  const SizedBox(height: 20),
                  // Footer
                  const Footer(),
                ],
              ),
            ),
      // ),
    );
  }
}