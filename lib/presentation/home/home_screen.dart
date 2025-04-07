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

  // List<Map<String, dynamic>> _topAttractions = [];

  @override
  void initState() {
    super.initState();

    _filteredCities = List.from(cities);
    _selectedCity = _filteredCities.isNotEmpty ? _filteredCities[0] : null;

    final allAttractions = cities
        .expand((city) => city['attractions'] as List<Map<String, dynamic>>)
        .toList();

    allAttractions.sort(
      (a, b) => (b['rating'] as double).compareTo(a['rating'] as double),
    );

    // _topAttractions = allAttractions.take(10).toList();

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
                      cities: _filteredCities,
                      onCitySelected: _onCitySelected,
                    ),
                  SizedBox(height: 20.h),
                  FeaturedAttractions(),
                  SizedBox(height: 20.h),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 16.w),
                  //   child: const Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       'Need Help?',
                  //       style: TextStyle(
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.deepPurple,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 10.h),
                  const FAQWidget(), // ← Add this line here
                  SizedBox(height: 20.h), // Optional spacing
                  Footer(),
                ],
              ),
            ),
    );
  }
}
