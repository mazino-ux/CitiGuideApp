import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GallerySection extends StatelessWidget {
  final List<String> images;

  const GallerySection({super.key, required this.images});

  // Determine the scale factor: mobile = 1.0, tablet = 0.8, desktop = 0.65.
  double _scaleFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1.0;
    if (width >= 600 && width < 1100) return 0.8;
    return 0.65;
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = _scaleFactor(context);

    if (images.isEmpty) {
      return Container(
        height: 150.h * scaleFactor,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported, size: 48.sp * scaleFactor),
              SizedBox(height: 8.h * scaleFactor),
              Text(
                'No images available',
                style: TextStyle(fontSize: 16.sp * scaleFactor),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gallery',
          style: TextStyle(
            fontSize: 20.sp * scaleFactor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h * scaleFactor),
        SizedBox(
          height: 180.h * scaleFactor,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < images.length - 1 ? 12.w * scaleFactor : 0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: CachedNetworkImage(
                    imageUrl: images[index],
                    width: 250.w * scaleFactor,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.broken_image,
                        size: 48.sp * scaleFactor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
