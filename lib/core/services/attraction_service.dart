import 'package:citi_guide_app/models/attraction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttractionService {
  final _supabase = Supabase.instance.client;

  // Fetch attractions by city ID
  Future<List<Attraction>> getAttractionsByCity(String cityId) async {
    try {
      final response = await _supabase
          .from('attractions')
          .select()
          .eq('city_id', cityId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response)
          .map((data) => Attraction.fromMap(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch attractions: $e');
    }
  }

  // Get a single attraction by ID
  Future<Attraction> getAttractionById(String id) async {
    try {
      final response = await _supabase
          .from('attractions')
          .select()
          .eq('id', id)
          .single();

      return Attraction.fromMap(response);
    } catch (e) {
      throw Exception('Failed to fetch attraction: $e');
    }
  }

  // Search attractions by query
  Future<List<Attraction>> searchAttractions(String query) async {
    try {
      final response = await _supabase
          .from('attractions')
          .select()
          .ilike('name', '%$query%')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response)
          .map((data) => Attraction.fromMap(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to search attractions: $e');
    }
  }
}
