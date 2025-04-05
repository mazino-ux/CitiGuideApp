import 'dart:typed_data';

import 'package:citi_guide_app/models/city.dart';
// import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// lib/core/services/city_service.dart
class CityService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<City>> getCities() async {
    final response = await _supabase.from('cities').select('*').order('name');
    return response.map((city) => City.fromMap(city)).toList();
  }

  Future<City> getCityById(String id) async {
    final response = await _supabase.from('cities').select('*').eq('id', id).single();
    return City.fromMap(response);
  }

  Future<String> addCity(City city, Uint8List imageBytes) async {
    // Upload image first
    final filePath = 'cities/${city.id}/cover.jpg';
    await _supabase.storage.from('cities').uploadBinary(filePath, imageBytes);
    
    final imageUrl = _supabase.storage.from('cities').getPublicUrl(filePath);
    
    // Then insert city record
    await _supabase.from('cities').insert({
      'id': city.id,
      'name': city.name,
      'description': city.description,
      'image_url': imageUrl,
    });
    
    return imageUrl;
  }

  Future<void> updateCity(City city, {Uint8List? newImageBytes}) async {
    String? imageUrl;
    
    if (newImageBytes != null) {
      // Upload new image
      final filePath = 'cities/${city.id}/cover.jpg';
      await _supabase.storage.from('cities').uploadBinary(filePath, newImageBytes);
      imageUrl = _supabase.storage.from('cities').getPublicUrl(filePath);
    }
    
    await _supabase.from('cities').update({
      'name': city.name,
      'description': city.description,
      if (imageUrl != null) 'image_url': imageUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', city.id);
  }

  Future<void> deleteCity(String id) async {
    await _supabase.from('cities').delete().eq('id', id);
    // Optionally delete associated images from storage
  }
}