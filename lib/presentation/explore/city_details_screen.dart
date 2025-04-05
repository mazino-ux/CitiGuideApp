import 'package:citi_guide_app/presentation/attractions/attraction_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class CityScreen extends StatelessWidget {
  final Map<String, dynamic> city;

  const CityScreen({Key? key, required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1100;
    final bool isDesktop = screenWidth >= 1100;

    final double factor = isMobile ? 1.0 : (isTablet ? 0.8 : 0.65);

    int crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 4);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: isDesktop ? 270.h : 250.h * factor,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                margin: EdgeInsets.only(
                  top: 7.h,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 6.h,
                  horizontal: 10.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  "Explore / ${city['name']}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop ? 5.sp : 16.sp * factor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    city['image'],
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
              child: Text(
                "Top Attractions in ${city['name']}",
                style: TextStyle(
                  fontSize: isDesktop ? 7.sp : 18.sp * factor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: isDesktop ? 15.h : 12.h,
                childAspectRatio: isDesktop ? 0.8 : 1.2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final attraction = city['attractions'][index];
                  String imageUrl = attraction['images'] is List
                      ? (attraction['images'][0] as String? ?? '')
                      : (attraction['images'] as String? ?? '');
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => AttractionDetail(attraction: attraction));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        image: DecorationImage(
                          image: imageUrl.isNotEmpty
                              ? AssetImage(imageUrl)
                              : AssetImage('assets/images/placeholder.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8.h,
                            left: 8.w,
                            right: 8.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  attraction['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isDesktop ? 5.sp : 16.sp * factor,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 1),
                                        blurRadius: 2,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                RatingBarIndicator(
                                  rating: attraction['rating'] is num
                                      ? (attraction['rating'] as num).toDouble()
                                      : 0.0,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: isDesktop ? 8.sp : 16.sp * factor,
                                  ),
                                  itemCount: 5,
                                  itemSize: isDesktop ? 8.sp : 16.sp * factor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: city['attractions'].length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
