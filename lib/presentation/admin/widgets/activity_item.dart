import 'package:flutter/material.dart';

class ActivityItem extends StatelessWidget {
  final int index;

  const ActivityItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {'title': 'New attraction added', 'time': '2 hours ago', 'icon': Icons.place},
      {'title': 'User registration', 'time': '5 hours ago', 'icon': Icons.person_add},
      {'title': 'Review reported', 'time': '1 day ago', 'icon': Icons.flag},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(135),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activities[index]['icon'] as IconData,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activities[index]['title'] as String,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  activities[index]['time'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(208),
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}