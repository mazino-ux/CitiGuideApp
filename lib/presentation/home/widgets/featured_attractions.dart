import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:citi_guide_app/widgets/attraction_card.dart';
// import 'package:citi_guide_app/core/theme/app_theme.dart';
import 'package:citi_guide_app/presentation/attractions/attraction_detail.dart';

class FeaturedAttractions extends StatelessWidget {
  const FeaturedAttractions({super.key});

  void _navigateToDetail(BuildContext context, String name, String image, double rating) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttractionDetail(
          name: name,
          image: image,
          rating: rating,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.7; 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Featured Attractions',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color:  Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 250, 
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: attractions.length,
            itemBuilder: (context, index) {
              final attraction = attractions[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => _navigateToDetail(
                          context,
                          attraction['name'] as String,
                          attraction['image'] as String,
                          attraction['rating'] as double,
                        ),
                        child: SizedBox(
                          width: cardWidth,
                          child: AttractionCard(
                            name: attraction['name'] as String,
                            image: attraction['image'] as String,
                            rating: attraction['rating'] as double,
                            category: attraction['category'] as String,
                            distance: attraction['distance'] as String,
                          ),
                        ),
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

  static const attractions = [
    {
      'name': 'Eiffel Tower',
      'image': 'assets/images/shot_forest.jpg',
      'rating': 4.8,
      'category': 'Landmark',
      'distance': '2.5 km',
    },
    {
      'name': 'Statue of Liberty',
      'image': 'assets/images/shot_forest.jpg',
      'rating': 4.7,
      'category': 'Landmark',
      'distance': '5.0 km',
    },
    {
      'name': 'Shibuya Crossing',
      'image': 'assets/images/shot_forest.jpg',
      'rating': 4.6,
      'category': 'Landmark',
      'distance': '1.2 km',
    },
  ];
}