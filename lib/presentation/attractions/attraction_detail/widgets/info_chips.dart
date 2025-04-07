import 'package:flutter/material.dart';

class InfoChips extends StatelessWidget {
  final String? category;
  final String? openingHours;
  final bool isFeatured;

  const InfoChips({
    super.key,
    required this.category,
    required this.openingHours,
    required this.isFeatured,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (category != null)
          Chip(
            avatar: const Icon(Icons.category_rounded, size: 16),
            label: Text(category!),
            backgroundColor: Colors.blue[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        if (openingHours != null)
          Chip(
            avatar: const Icon(Icons.access_time_rounded, size: 16),
            label: Text(openingHours!),
            backgroundColor: Colors.orange[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        if (isFeatured)
          Chip(
            avatar: const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
            label: const Text('Featured'),
            backgroundColor: Colors.amber[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      ],
    );
  }
}