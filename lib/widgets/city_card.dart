import 'package:flutter/material.dart';
import 'package:citi_guide_app/models/city.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CityCard extends StatelessWidget {
  final City city;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isFeatured;

  const CityCard({
    super.key,
    required this.city,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimationConfiguration.staggeredList(
      position: city.id.hashCode,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              color: colorScheme.surface,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // City Image with Hero Animation
                    Hero(
                      tag: 'city-image-${city.id}',
                      child: city.imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: city.imageUrl!,
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: colorScheme.surfaceContainerHighest,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => 
                                _buildPlaceholder(colorScheme),
                            )
                          : _buildPlaceholder(colorScheme),
                    ),

                    // City Information Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Row with Actions
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  city.name,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              _buildActionButtons(colorScheme),
                            ],
                          ),

                          // Description (if available)
                          if (city.description != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              city.description!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],

                          // Metadata Section
                          const SizedBox(height: 12),
                          _buildMetadataRow(theme, colorScheme),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      height: 150,
      width: double.infinity,
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.location_city_rounded,
          size: 48,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit_rounded, color: colorScheme.primary),
            onPressed: onEdit,
            tooltip: 'Edit city',
          ),
          IconButton(
            icon: Icon(Icons.delete_rounded, color: Colors.redAccent),
            onPressed: onDelete,
            tooltip: 'Delete city',
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            'Created: ${_formatDate(city.createdAt)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.update_rounded,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            'Updated: ${_formatDate(city.updatedAt)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}