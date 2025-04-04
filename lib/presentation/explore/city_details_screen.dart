import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CityScreen extends StatelessWidget {
  final Map<String, dynamic> city;

  const CityScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1100;
    // final bool isDesktop = screenWidth >= 1100;

    final double factor = isMobile ? 1.0 : (isTablet ? 0.85 : 0.7);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 250.h * factor,
                child: Image.asset(
                  city['image'],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 40.h,
                left: 16.w,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                bottom: 20.h,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(176),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      "Explore / ${city['name']}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp * factor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              "Top Attractions in ${city['name']}",
              style: TextStyle(
                fontSize: 18.sp * factor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: city['attractions'].length,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemBuilder: (context, index) {
                final attraction = city['attractions'][index];

                String imageUrl = attraction['images'] is List<String>
                    ? attraction['images'][0]
                    : attraction['images'];

                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          bottomLeft: Radius.circular(10.r),
                        ),
                        child: Image.asset(
                          imageUrl,
                          width: 100.w * factor,
                          height: 80.h * factor,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              attraction['name'],
                              style: TextStyle(
                                fontSize: 16.sp * factor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            RatingBarIndicator(
                              rating: attraction['rating'] ?? 0.0,
                              itemBuilder: (context, index) =>
                                  const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 16.sp * factor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
