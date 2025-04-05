import 'package:citi_guide_app/presentation/explore/city_details_screen.dart';
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
  int _getCrossAxisCount(double width) {
    if (width >= 1200) {
      return 4;
    } else if (width >= 800) {
      return 3;
    } else {
      return 2;
    }
  }

  double _getChildAspectRatio(double width) {
    if (width >= 1200) {
      return 0.8;
    } else if (width >= 800) {
      return 1.0;
    } else {
      return 1.2;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1100;
    final bool isDesktop = screenWidth >= 1100;

    final double factor = isMobile ? 1.0 : (isTablet ? 0.8 : 0.65);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore Cities',
          style: TextStyle(
            fontSize: isDesktop ? 12.sp : 21.sp * factor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 10.h,
        ),
        child: GridView.builder(
          itemCount: widget.cities.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getCrossAxisCount(screenWidth),
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: _getChildAspectRatio(screenWidth),
          ),
          itemBuilder: (context, index) {
            final city = widget.cities[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => CityScreen(city: city));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        city['image']!,
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
                            horizontal: isDesktop ? 10.w : 8.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(135),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            city['name']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 6.sp : 16.sp * factor,
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
      ),
    );
  }
}
