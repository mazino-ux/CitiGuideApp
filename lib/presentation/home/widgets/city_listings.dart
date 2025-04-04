import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:citi_guide_app/widgets/city_card.dart';
import 'package:citi_guide_app/models/city.dart';

class CityListings extends StatelessWidget {
  final List<City> cities;
  final Function(City) onCityTap;
  final Function(City) onCityEdit;
  final Function(City) onCityDelete;

  const CityListings({
    super.key, 
    required this.cities,
    required this.onCityTap,
    required this.onCityEdit,
    required this.onCityDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      return CityCard(
                        city: cities[index],
                        onTap: () => onCityTap(cities[index]),
                        onEdit: () => onCityEdit(cities[index]),
                        onDelete: () => onCityDelete(cities[index]),
                      );
                    },
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