import 'package:citi_guide_app/presentation/explore/city_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:citi_guide_app/presentation/home/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citi_guide_app/models/city.dart';

class HeroSection extends StatelessWidget {
  final String city;
  final String image;
  final String description;
  final List<City> cities;
  final Function(City) onCitySelected;

  const HeroSection({
    super.key,
    required this.city,
    required this.image,
    required this.description,
    required this.cities,
    required this.onCitySelected,
  });

   List<Map<String, String>> _convertCitiesForSearch(List<City> cities) {
    return cities.map((city) => {
      'name': city.name,
      'image': city.imageUrl ?? '',
      'description': city.description ?? ''
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1100;
    final bool isDesktop = width >= 1100;

    // Define scaling factors.
    final double factor = isMobile ? 1.0 : (isTablet ? 0.8 : 0.65);

    // Responsive sizes using the factor.
    final double arrowIconSize = 30.w * factor;
    final double searchIconSize = 20.w * factor;
    final double cityFontSize = 48.sp * factor;
    final double descriptionFontSize = 20.sp * factor;
    final double thumbnailContainerHeight = 150.h * factor;
    final double thumbnailWidth = 90.w * factor;
    final double listingArrowSize = 14.w * factor;
    final EdgeInsets bottomPadding = EdgeInsets.only(bottom: 20.h * factor);

    // Find current index for navigation arrows.
    final currentIndex = cities.indexWhere((c) => c.name == city);

    return Container(
      height: (screenSize.height - 60.h),
      width: screenSize.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(color: Colors.black.withAlpha(80)),
          Positioned(
            top: 10.h,
            left: 10.w,
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: isDesktop ? 10.w : searchIconSize,
              ),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: HomeSearchBar(
                    cities: _convertCitiesForSearch(cities),
                  ),
                
                );
              },
            ),
          ),
          Positioned(
            left: 16.w,
            top: 0,
            bottom: 0,
            child: Center(
              child: Visibility(
                visible: currentIndex > 0,
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: arrowIconSize,
                  ),
                  onPressed: () {
                    if (currentIndex <= 0) return;
                    onCitySelected(cities[currentIndex - 1]);
                  },
                ),
              ),
            ),
          ),
          Positioned(
            right: 16.w,
            top: 0,
            bottom: 0,
            child: Center(
              child: Visibility(
                visible: currentIndex < cities.length - 1,
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: arrowIconSize,
                  ),
                  onPressed: () {
                    if (currentIndex == -1) return;
                    onCitySelected(cities[(currentIndex + 1) % cities.length]);
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  city,
                  style: TextStyle(
                    fontSize: cityFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h * factor),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: descriptionFontSize,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: bottomPadding,
              child: SizedBox(
                height: isDesktop ? 120.h : thumbnailContainerHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: cities.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w * factor),
                  itemBuilder: (context, index) {
                    final cityItem = cities[index];
                    final isSelected = cityItem.name == city;
                    return GestureDetector(
                      onTap: () => onCitySelected(cityItem),
                      child: Container(
                        width: isDesktop ? 40.w : thumbnailWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: isSelected
                              ? isDesktop
                                  ? Border.all(
                                      color: Colors.white,
                                      width: 0.5.w,
                                    )
                                  : Border.all(
                                      color: Colors.white,
                                      width: 1.w,
                                    )
                              : null,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: cityItem.imageUrl ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image),
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                    color: Colors.black.withAlpha(128)),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.all(4.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          cityItem.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isDesktop
                                                ? 5.sp
                                                : 12.sp * factor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.to(() => CityScreen(
                                                city: cityItem.toMap(),
                                              ));
                                        },
                                        child: Icon(
                                          Icons.arrow_forward,
                                          size: isDesktop
                                              ? 5.w
                                              : listingArrowSize,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}