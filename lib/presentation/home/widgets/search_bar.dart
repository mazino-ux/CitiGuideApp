import 'package:citi_guide_app/presentation/explore/explore_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeSearchBar extends SearchDelegate<String> {
  final List<Map<String, String>> cities;

  HomeSearchBar({required this.cities});

  double _scalingFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1.0;
    if (width >= 600 && width < 1100) return 0.9;
    return 0.8;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final double factor = _scalingFactor(context);
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        color: Colors.black.withOpacity(0.7),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70, fontSize: 18.sp * factor),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(color: Colors.white, fontSize: 18.sp * factor),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    final double factor = _scalingFactor(context);
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear, size: 24.sp * factor),
          color: Colors.white,
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    final double factor = _scalingFactor(context);
    return IconButton(
      icon: Icon(Icons.arrow_back, size: 24.sp * factor),
      color: Colors.white,
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final double factor = _scalingFactor(context);
    final results = cities
        .where(
            (city) => city['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final city = results[index];
        return ListTile(
          title: Text(
            city['name']!,
            style: TextStyle(color: Colors.white, fontSize: 16.sp * factor),
          ),
          onTap: () {
            close(context, city['name']!);
            Get.to(() => ExploreScreen(cities: cities));
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final double factor = _scalingFactor(context);
    final suggestions = cities
        .where(
            (city) => city['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final city = suggestions[index];
        return ListTile(
          title: Text(
            city['name']!,
            style: TextStyle(color: Colors.white, fontSize: 16.sp * factor),
          ),
          onTap: () {
            query = city['name']!;
            showResults(context);
          },
        );
      },
    );
  }
}
