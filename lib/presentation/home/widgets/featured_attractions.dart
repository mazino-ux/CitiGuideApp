import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:citi_guide_app/widgets/attraction_card.dart';
import 'package:citi_guide_app/presentation/attractions/attraction_detail.dart';

class FeaturedAttractions extends StatelessWidget {
  final List<Map<String, dynamic>> attractions;

  const FeaturedAttractions({
    super.key,
    required this.attractions,
  });

  void _navigateToDetail(
      BuildContext context, Map<String, dynamic> attraction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttractionDetail(
          attraction: attraction,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Featured Attractions',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 240, // Adjust height based on your card size
          child: AnimationLimiter(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: attractions.length,
              itemBuilder: (context, index) {
                final attraction = attractions[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () => _navigateToDetail(context, attraction),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: AttractionCard(
                            name: attraction['name']?.toString() ?? 'Unknown',
                            image: attraction['image']?.toString() ??
                                'assets/images/placeholder.jpg',
                            rating: (attraction['rating'] ?? 0).toDouble(),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
