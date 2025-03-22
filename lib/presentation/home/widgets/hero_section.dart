import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemCount: 3, // Number of hero cards
        itemBuilder: (context, index) {
          final cities = ['New York', 'Paris', 'Tokyo'];
          final images = [
            'assets/images/new_york.jpg',
            'assets/images/paris.jpg',
            'assets/images/tokyo.jpg',
          ];
          return _buildHeroCard(cities[index], images[index]);
        },
      ),
    );
  }

  Widget _buildHeroCard(String city, String image) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          city,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.black.withAlpha(128),
              ),
            ],
          ),
        ),
      ),
    );
  }
}