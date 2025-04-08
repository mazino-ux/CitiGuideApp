import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttractionCard extends StatelessWidget {
  final Map<String, dynamic> attraction;
  final VoidCallback onTap;

  const AttractionCard({
    required this.attraction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1100;
    final bool isDesktop = screenWidth >= 1100;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isDesktop ? 10.r : 14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isDesktop ? 10.r : 14.r),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: attraction['image_url'] ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary.withAlpha(128),
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(178),
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 6.w : 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        attraction['name'] ?? 'Unnamed Attraction',
                        style: TextStyle(
                          fontSize: isDesktop
                              ? 7.sp
                              : isTablet
                                  ? 10.sp
                                  : 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 4.h),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: isDesktop
                                ? 5.sp
                                : isTablet
                                    ? 10.sp
                                    : 14.sp,
                            color: Colors.white.withAlpha(204),
                          ),
                          SizedBox(width: isDesktop ? 2.w : 4.w),
                          Expanded(
                            child: Text(
                              attraction['location'] ??
                                  'Location not specified',
                              style: TextStyle(
                                fontSize: isDesktop
                                    ? 5.sp
                                    : isTablet
                                        ? 8.sp
                                        : 12.sp,
                                color: Colors.white.withAlpha(204),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                          height: isDesktop
                              ? 3.h
                              : isTablet
                                  ? 5.h
                                  : 8.h),

                      // Rating and Category
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Rating
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop
                                  ? 3.w
                                  : isTablet
                                      ? 5.w
                                      : 8.w,
                              vertical: isDesktop
                                  ? 2.h
                                  : isTablet
                                      ? 3.h
                                      : 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: isDesktop
                                      ? 6.sp
                                      : isTablet
                                          ? 10.sp
                                          : 14.sp,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  (attraction['rating']?.toStringAsFixed(1) ??
                                      '0.0'),
                                  style: TextStyle(
                                    fontSize: isDesktop
                                        ? 5.sp
                                        : isTablet
                                            ? 8.sp
                                            : 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Category
                          if (attraction['category'] != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop
                                    ? 3.w
                                    : isTablet
                                        ? 5.w
                                        : 8.w,
                                vertical: isDesktop
                                    ? 2.h
                                    : isTablet
                                        ? 3.h
                                        : 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(51),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withAlpha(76),
                                ),
                              ),
                              child: Text(
                                attraction['category'],
                                style: TextStyle(
                                  fontSize: isDesktop
                                      ? 5.sp
                                      : isTablet
                                          ? 7.sp
                                          : 10.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Featured Badge
              if (attraction['is_featured'] == true)
                Positioned(
                  top: 12.h,
                  left: isDesktop ? 6.w : 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop
                          ? 3.w
                          : isTablet
                              ? 5.w
                              : 8.w,
                      vertical: isDesktop
                          ? 2.h
                          : isTablet
                              ? 3.h
                              : 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'Featured',
                      style: TextStyle(
                        fontSize: isDesktop
                            ? 5.sp
                            : isTablet
                                ? 7.sp
                                : 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
