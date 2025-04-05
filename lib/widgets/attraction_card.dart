import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttractionCard extends StatelessWidget {
  final String name;
  final String image;
  final double rating;

  const AttractionCard({
    super.key,
    required this.name,
    required this.image,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Define scale factors
    double cardWidth;
    double titleFontSize;
    double ratingFontSize;
    double iconSize;

    if (screenWidth >= 1024) {
      // Desktop
      cardWidth = 100.w;
      titleFontSize = 6.sp;
      ratingFontSize = 6.sp;
      iconSize = 7.sp;
    } else if (screenWidth >= 600) {
      // Tablet
      cardWidth = 120.w;
      titleFontSize = 10.sp;
      ratingFontSize = 10.sp;
      iconSize = 12.sp;
    } else {
      // Mobile
      cardWidth = 150.w;
      titleFontSize = 16.sp;
      ratingFontSize = 14.sp;
      iconSize = 14.sp;
    }

    return Container(
      width: cardWidth,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(128),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.secondary,
                      size: iconSize,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        fontSize: ratingFontSize,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
