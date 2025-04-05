import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:citi_guide_app/widgets/attraction_card.dart';
import 'package:citi_guide_app/presentation/attractions/attraction_detail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeaturedAttractions extends StatefulWidget {
  const FeaturedAttractions({super.key});

  @override
  State<FeaturedAttractions> createState() => _FeaturedAttractionsState();
}

class _FeaturedAttractionsState extends State<FeaturedAttractions> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _attractions = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchFeaturedAttractions();
  }

  Future<void> _fetchFeaturedAttractions() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await _supabase
          .from('attractions')
          .select('''
            id, 
            name, 
            image_url, 
            rating, 
            category,
            location,
            description
          ''')
          .eq('is_featured', true)
          .order('created_at', ascending: false)
          .limit(5);

      if (response.isEmpty) {
        // If no featured attractions, get some regular ones as fallback
        final fallbackResponse = await _supabase
            .from('attractions')
            .select('''
              id, 
              name, 
              image_url, 
              rating, 
              category,
              location,
              description
            ''')
            .order('rating', ascending: false)
            .limit(3);
            
        setState(() {
          _attractions = List<Map<String, dynamic>>.from(fallbackResponse);
          _isLoading = false;
        });
      } else {
        setState(() {
          _attractions = List<Map<String, dynamic>>.from(response);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load attractions: $e')),
        );
      }
    }
  }

  void _navigateToDetail(BuildContext context, String attractionId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttractionDetail(
          attractionId: attractionId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.7;

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
          height: 250,
          child: _buildAttractionsList(cardWidth),
        ),
      ],
    );
  }

  Widget _buildAttractionsList(double cardWidth) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Failed to load attractions'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchFeaturedAttractions,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_attractions.isEmpty) {
      return const Center(
        child: Text('No attractions available'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      scrollDirection: Axis.horizontal,
      itemCount: _attractions.length,
      itemBuilder: (context, index) {
        final attraction = _attractions[index];
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            horizontalOffset: 50.0,
            child: FadeInAnimation(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _navigateToDetail(context, attraction['id']),
                  child: SizedBox(
                    width: cardWidth,
                    child: AttractionCard(
                      name: attraction['name'] ?? 'Unnamed Attraction',
                      image: attraction['image_url'] ?? '',
                      rating: (attraction['rating'] as num?)?.toDouble() ?? 0.0,
                      category: attraction['category'] ?? 'Unknown',
                      location: attraction['location'] ?? 'Location not specified', distance: null,
                    ),
                  ),
                ),
              ),

            ),
          ),
        );
      },
    );
  }
}

