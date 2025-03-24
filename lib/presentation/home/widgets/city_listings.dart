import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:citi_guide_app/widgets/city_card.dart';
// import 'package:citi_guide_app/core/theme/app_theme.dart';

class CityListings extends StatelessWidget {
  final List<Map<String, String>> cities;

  const CityListings({super.key, required this.cities});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Explore Cities',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: AnimationConfiguration.staggeredList(
              position: 0,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: cities.map((city) {
                      return CityCard(
                        city: city['name']!,
                        image: city['image']!,
                        description: city['description']!,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}