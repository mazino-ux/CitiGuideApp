import 'package:flutter/material.dart';
import 'package:citi_guide_app/presentation/admin/screens/add_attraction_screen.dart';
import 'package:citi_guide_app/presentation/admin/screens/edit_attraction_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AttractionsScreen extends StatefulWidget {
  final String cityId;
  const AttractionsScreen({super.key, required this.cityId});

  @override
  State<AttractionsScreen> createState() => _AttractionsScreenState();
}

class _AttractionsScreenState extends State<AttractionsScreen> {
  late String currentCityId;
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _attractions = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    currentCityId = widget.cityId; 
    _fetchAttractions();
  }

  Future<void> _fetchAttractions() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await _supabase
          .from('attractions')
          .select('*')
          .eq('city_id', currentCityId)
          .order('created_at', ascending: false)
          .timeout(const Duration(seconds: 10));

      setState(() {
        _attractions = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });

      // Handle 403 unauthorized error
      if (e is PostgrestException && e.code == '403') {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }

      if (mounted) {
        _showError('Failed to load attractions: ${e.toString()}');
      }
    }
  }

  Future<void> _deleteAttraction(String id) async {
    try {
      await _supabase.from('attractions').delete().eq('id', id);
      if (mounted) {
        _showSuccess('Attraction deleted successfully');
        _fetchAttractions();
      }
    } catch (e) {
      // Handle 403 unauthorized error
      if (e is PostgrestException && e.code == '403') {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }

      if (mounted) {
        _showError('Failed to delete attraction: ${e.toString()}');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.greenAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _confirmDelete(String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Delete Attraction', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAttraction(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Attractions', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white),
            onPressed: () async {
              try {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAttractionScreen(cityId: currentCityId),
                  ),
                );
                _fetchAttractions();
              } catch (e) {
                if (e is PostgrestException && e.code == '403') {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              }
            },
            tooltip: 'Add new attraction',
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _fetchAttractions,
            tooltip: 'Refresh list',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading cute attractions...'),
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text('Oops! Something went wrong'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchAttractions,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_attractions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore_rounded, size: 64, color: Colors.blueAccent),
            const SizedBox(height: 16),
            Text(
              'No attractions found',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddAttractionScreen(cityId: currentCityId),
                    ),
                  );
                  _fetchAttractions();
                } catch (e) {
                  if (e is PostgrestException && e.code == '403') {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                }
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create First Attraction'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchAttractions,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: AnimationLimiter(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: _attractions.length,
          itemBuilder: (context, index) => AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: _buildAttractionCard(_attractions[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttractionCard(Map<String, dynamic> attraction) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Add attraction detail navigation here if needed
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image
                Expanded(
                  child: attraction['image_url'] != null
                      ? CachedNetworkImage(
                          imageUrl: attraction['image_url'],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: colorScheme.surfaceContainerHigh,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: colorScheme.surfaceContainerHigh,
                            child: Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                size: 48,
                                color: colorScheme.error,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: colorScheme.surfaceContainerHigh,
                          child: Center(
                            child: Icon(
                              Icons.photo_rounded,
                              size: 48,
                              color: colorScheme.onSurface.withAlpha(120),
                            ),
                          ),
                        ),
                ),
                // Details
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attraction['name'] ?? 'Unnamed Attraction',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: colorScheme.onSurface.withAlpha(150),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              attraction['location'] ?? 'Unknown location',
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            attraction['rating']?.toStringAsFixed(1) ?? '0.0',
                            style: theme.textTheme.bodySmall,
                          ),
                          const Spacer(),
                          Text(
                            attraction['price'] != null
                                ? '\$${attraction['price'].toStringAsFixed(2)}'
                                : 'Free',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Edit/Delete buttons
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(120),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.white),
                      onPressed: () async {
                        try {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAttractionScreen(
                                attraction: attraction,
                              ),
                            ),
                          );
                          _fetchAttractions();
                        } catch (e) {
                          if (e is PostgrestException && e.code == '403') {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded, size: 18, color: Colors.white),
                      onPressed: () => _confirmDelete(
                        attraction['id'].toString(),
                        attraction['name'] ?? 'this attraction',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Featured badge
            if (attraction['is_featured'] == true)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber[700],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      const Text(
                        'FEATURED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}