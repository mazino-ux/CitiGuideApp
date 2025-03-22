import 'package:citi_guide_app/widgets/attraction.card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:citi_guide_app/widgets/city_card.dart';
// import 'package:citi_guide_app/widgets/attraction_card.dart';
import 'package:citi_guide_app/core/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Simulate data loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _isLoading
          ? Center(
              child: Lottie.asset(
                "assets/lottie/loading.json", 
                width: 200,
                height: 200,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Search Bar
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  // Hero Section
                  _buildHeroSection(),
                  const SizedBox(height: 20),
                  // City Listings
                  _buildCityListings(),
                  const SizedBox(height: 20),
                  // Featured Attractions
                  _buildFeaturedAttractions(),
                  const SizedBox(height: 20),
                  // Footer
                  _buildFooter(),
                ],
              ),
            ),
      // ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for cities...',
          prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: (value) {
          // Implement search functionality
        },
      ),
    );
  }

  Widget _buildHeroSection() {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemCount: 3, // Number of hero cards
        itemBuilder: (context, index) {
          final cities = ['New York', 'Paris', 'Tokyo'];
          final images = [
            '/Users/owner/Desktop/ALLCDDOCUMENT/PROGRAM_APP/CODE_2025/FLUTTER/citi_guide_app/assets/images/shot_forest.jpg',
            'assets/images/paris.jpg',
            'assets/images/tokyo.jpg',
          ];
          return _buildHeroCard(cities[index], images[index]);
        },
      ),
    );
  }

  Widget _buildHeroCard(String city, String image) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          city,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.black.withAlpha(128),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityListings() {
    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Explore Cities',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: AnimationConfiguration.staggeredList(
              position: 0,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      CityCard(
                        city: 'New York',
                        image: '/Users/owner/Desktop/ALLCDDOCUMENT/PROGRAM_APP/CODE_2025/FLUTTER/citi_guide_app/assets/images/shot_forest.jpg',
                        description: 'The Big Apple',
                      ),
                      CityCard(
                        city: 'Paris',
                        image: 'assets/images/paris.jpg',
                        description: 'City of Love',
                      ),
                      CityCard(
                        city: 'Tokyo',
                        image: 'assets/images/tokyo.jpg',
                        description: 'Land of the Rising Sun',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedAttractions() {
    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Featured Attractions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: AnimationConfiguration.staggeredList(
              position: 1,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      AttractionCard(
                        name: 'Eiffel Tower',
                        image: 'assets/images/eiffel_tower.jpg',
                        rating: 4.8,
                      ),
                      AttractionCard(
                        name: 'Statue of Liberty',
                        image: 'assets/images/statue_of_liberty.jpg',
                        rating: 4.7,
                      ),
                      AttractionCard(
                        name: 'Shibuya Crossing',
                        image: 'assets/images/shibuya_crossing.jpg',
                        rating: 4.6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

    
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blueGrey, // Replace with AppTheme.primaryColor if needed
      child: Column(
        children: [
          const Text(
            'City Guide App',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '© 2023 City Guide. All rights reserved.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.facebook, color: Colors.white),
                onPressed: () {
                  // Handle Facebook link
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.twitter, color: Colors.white),
                onPressed: () {
                  // Handle Twitter link
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.white),
                onPressed: () {
                  // Handle Instagram link
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}