import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CityAttractionsScreen extends StatelessWidget {
  final Map<String, dynamic> city;

  const CityAttractionsScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(city['name']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // City header
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                city['image'],
                height: 200.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              city['name'],
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.place, size: 16.w, color: Colors.grey),
                SizedBox(width: 4.w),
                Text(
                  city['location'] ?? 'Unknown location',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'Attractions',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            
            // Attractions list
            if (city['attractions'] != null && (city['attractions'] as List).isNotEmpty)
              ...(city['attractions'] as List<dynamic>).map((attraction) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: AttractionCard(attraction: attraction),
                );
              }).toList()
            else
              Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 40.w, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text('No attractions found for this city'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AttractionCard extends StatelessWidget {
  final dynamic attraction;

  const AttractionCard({super.key, required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              attraction['image_url'] ?? '',
              height: 150.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attraction['name'] ?? 'Unnamed Attraction',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.star, size: 16.w, color: Colors.amber),
                    SizedBox(width: 4.w),
                    Text(
                      (attraction['rating']?.toStringAsFixed(1) ?? '0.0') + ' rating',
                      style: TextStyle(fontSize: 14.sp),
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