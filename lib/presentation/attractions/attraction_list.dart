import 'package:flutter/material.dart';
import 'package:citi_guide_app/widgets/attraction_card.dart';
import 'package:citi_guide_app/core/theme/app_theme.dart';

class AttractionListScreen extends StatefulWidget {
  const AttractionListScreen({super.key});

  @override
  _AttractionListScreenState createState() => _AttractionListScreenState();
}

class _AttractionListScreenState extends State<AttractionListScreen> {
  final List<Map<String, dynamic>> _attractions = [
    {
      'name': 'Eiffel Tower',
      'image': 'assets/images/eiffel_tower.jpg',
      'rating': 4.8,
      'category': 'Landmark',
      'distance': '2.5 km',
    },
    {
      'name': 'Statue of Liberty',
      'image': 'assets/images/statue_of_liberty.jpg',
      'rating': 4.7,
      'category': 'Landmark',
      'distance': '5.0 km',
    },
    {
      'name': 'Shibuya Crossing',
      'image': 'assets/images/shibuya_crossing.jpg',
      'rating': 4.6,
      'category': 'Landmark',
      'distance': '1.2 km',
    },
  ];

  String _selectedCategory = 'All';
  String _selectedSort = 'Rating';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attractions'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          // Filter and Sort Options
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Category Filter
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: ['All', 'Landmark', 'Restaurant', 'Hotel', 'Event']
                      .map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(width: 16),
                // Sort Option
                DropdownButton<String>(
                  value: _selectedSort,
                  items: ['Rating', 'Distance', 'Popularity']
                      .map((sort) {
                    return DropdownMenuItem(
                      value: sort,
                      child: Text(sort),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSort = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          // Attraction List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _attractions.length,
              itemBuilder: (context, index) {
                final attraction = _attractions[index];
                return AttractionCard(
                  name: attraction['name'],
                  image: attraction['image'],
                  rating: attraction['rating'],
                  category: attraction['category'],
                  distance: attraction['distance'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}