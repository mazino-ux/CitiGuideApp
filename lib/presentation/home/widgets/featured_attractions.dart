import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:citi_guide_app/widgets/attraction_card.dart';
import 'package:citi_guide_app/core/theme/app_theme.dart';

class FeaturedAttractions extends StatelessWidget {
  const FeaturedAttractions({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Featured Attractions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: AnimationConfiguration.staggeredList(
              position: 1,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      AttractionCard(
                        name: 'Eiffel Tower',
                        image: 'assets/images/eiffel_tower.jpg',
                        rating: 4.8,
                        category: 'Landmark', // Add category
                        distance: '2.5 km', // Add distance
                      ),
                      AttractionCard(
                        name: 'Statue of Liberty',
                        image: 'assets/images/statue_of_liberty.jpg',
                        rating: 4.7,
                        category: 'Landmark', // Add category
                        distance: '5.0 km', // Add distance
                      ),
                      AttractionCard(
                        name: 'Shibuya Crossing',
                        image: 'assets/images/shibuya_crossing.jpg',
                        rating: 4.6,
                        category: 'Landmark', // Add category
                        distance: '1.2 km', // Add distance
                      ),
                    ],
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