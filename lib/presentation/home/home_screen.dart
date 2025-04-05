import 'package:citi_guide_app/data/city_data.dart';
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

  List<Map<String, String>> _filteredCities = [];
  Map<String, String>? _selectedCity;

  @override
  void initState() {
    super.initState();

    _filteredCities = cities
        .map(
            (city) => city.map((key, value) => MapEntry(key, value.toString())))
        .toList();
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
          .map((city) =>
              city.map((key, value) => MapEntry(key, value.toString())))
          .where((city) =>
              city['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();

      if (!_filteredCities.contains(_selectedCity)) {
        _selectedCity = _filteredCities.isNotEmpty ? _filteredCities[0] : null;
      }
    });
  }

  void _onCitySelected(Map<String, String> city) {
    setState(() {
      _selectedCity = city;
    });
  }

  // Open the standard flutter search popup.
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: GestureDetector( // Wrap the Navbar with GestureDetector
          onTap: _openSearch,
          child: Navbar(isAdmin: isAdmin),
        ),
      ),
      // Add a search bar to the app bar 
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
                      cities: _filteredCities, // Pass converted cities
                      onCitySelected: _onCitySelected,
                    ),
                  SizedBox(height: 20.h),
                  FeaturedAttractions(),
                  SizedBox(height: 20.h),
                  Footer(),
                ],
              ),
            ),
    );
  }
}
