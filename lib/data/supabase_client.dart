import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClient {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchCities() async {
    final response = await supabase
        .from('cities')
        .select('*')
        .order('name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchAttractions(String cityId) async {
    final response = await supabase
        .from('attractions')
        .select('*')
        .eq('city_id', cityId)
        .order('name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }
}