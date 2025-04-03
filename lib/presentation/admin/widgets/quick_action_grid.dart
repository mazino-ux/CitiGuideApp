import 'package:flutter/material.dart';
import 'quick_action_card.dart';

class QuickActionsGrid extends StatelessWidget {
  QuickActionsGrid({super.key});

  final List<Map<String, dynamic>> actions = [
    {
      'title': 'Add Attraction',
      'icon': Icons.add_location_alt,
      'color': Colors.blue,
    },
    {
      'title': 'Manage Users',
      'icon': Icons.people,
      'color': Colors.green,
    },
    {
      'title': 'View Reports',
      'icon': Icons.bar_chart,
      'color': Colors.orange,
    },
    {
      'title': 'Settings',
      'icon': Icons.settings,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: actions.map((action) => QuickActionCard(action)).toList(),
        ),
      ],
    );
  }
}