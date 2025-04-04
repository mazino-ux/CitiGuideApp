import 'package:flutter/material.dart';
import 'package:citi_guide_app/models/city.dart';

class CityCard extends StatelessWidget {
  final City city;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CityCard({
    super.key,
    required this.city,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildCityImage(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (city.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        city.description!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityImage() {
    return Hero(
      tag: 'city-image-${city.id}',
      child: city.imageUrl != null
          ? CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(city.imageUrl!),
            )
          : const CircleAvatar(
              radius: 30,
              child: Icon(Icons.location_city, size: 30),
            ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 20),
          onPressed: onEdit,
        ),
        IconButton(
          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
          onPressed: onDelete,
        ),
      ],
    );
  }
}