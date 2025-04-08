import 'package:citi_guide_app/core/theme/app_theme.dart';
import 'package:citi_guide_app/presentation/explore/explore_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeSearchBar extends SearchDelegate<String> {
  final List<Map<String, String>> cities;

  HomeSearchBar({required this.cities});

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  bool _isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1100;
  }

  bool _isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  double _fontSize(BuildContext context) {
    if (_isDesktop(context)) return 6.sp;
    if (_isTablet(context)) return 12.sp;
    return 16.sp; // mobile
  }

  double _iconSize(BuildContext context) {
    if (_isDesktop(context)) return 6.sp;
    if (_isTablet(context)) return 15.sp;
    return 24.sp; // mobile
  }

  double _maxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1100) return 800;
    return double.infinity;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        color: AppTheme.primaryColor(context),
        iconTheme: IconThemeData(color: Colors.white, size: _iconSize(context)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.white70,
          fontSize: _fontSize(context),
        ),
        border: InputBorder.none,
        contentPadding:
            EdgeInsets.symmetric(vertical: _isDesktop(context) ? 5.h : 12.h),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: _fontSize(context),
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear, size: _iconSize(context)),
          color: Colors.white,
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, size: _iconSize(context)),
      color: Colors.white,
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchList(context, showSuggestions: false);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchList(context, showSuggestions: true);
  }

  Widget _buildSearchList(BuildContext context,
      {required bool showSuggestions}) {
    final fontSize = _fontSize(context);

    final results = cities
        .where(
            (city) => city['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    Widget itemBuilder(BuildContext context, int index) {
      final city = results[index];
      return Card(
        color: AppTheme.backgroundColor(context),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ListTile(
          title: Padding(
            padding:
                EdgeInsets.symmetric(vertical: _isDesktop(context) ? 3.h : 6.h),
            child: Text(
              city['name']!,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            query = city['name']!;
            if (showSuggestions) {
              showResults(context);
            } else {
              close(context, city['name']!);
              Get.to(() => ExploreScreen(cities: cities));
            }
          },
        ),
      );
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: _maxContentWidth(context)),
        padding: EdgeInsets.symmetric(
          horizontal: _isDesktop(context) ? 8.w : 12.w,
          vertical: _isDesktop(context) ? 4.h : 8.h,
        ),
        child: _isMobile(context)
            ? ListView.separated(
                itemCount: results.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: itemBuilder,
              )
            : GridView.builder(
                itemCount: results.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _isTablet(context) ? 2 : 4,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 3.5,
                ),
                itemBuilder: itemBuilder,
              ),
      ),
    );
  }
}
