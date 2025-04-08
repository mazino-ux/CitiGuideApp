import 'package:citi_guide_app/presentation/home/widgets/faq_widget.dart';
import 'package:citi_guide_app/presentation/home/widgets/navbar/navbar.dart';
import 'package:citi_guide_app/presentation/home/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _cities = [];

  @override
  void initState() {
    super.initState();
    _fetchFeaturedCities();
  }

  Future<void> _fetchFeaturedCities() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _supabase.from('cities').select('*');

      List<Map<String, dynamic>> fetchedCities =
          List<Map<String, dynamic>>.from(response);

      setState(() {
        _cities = fetchedCities;
        _filteredCities = List.from(fetchedCities);
        _selectedCity = _filteredCities.isNotEmpty ? _filteredCities[0] : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load cities: $e'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _filterCities(String query) {
    setState(() {
      _filteredCities = _cities
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
        cities: _cities
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
            cities: _cities,
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
                      image: _selectedCity!['image_url']!,
                      description: _selectedCity!['description']!,
                      cities: _cities,
                      onCitySelected: _onCitySelected,
                    ),
                  SizedBox(height: 20.h),
                  FeaturedAttractions(),
                  SizedBox(height: 20.h),
                  FAQWidget(),
                  SizedBox(height: 20.h),
                  Footer(),
                ],
              ),
            ),
    );
  }
}
