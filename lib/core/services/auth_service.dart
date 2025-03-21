import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Login
  Future<void> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) throw Exception('Login failed');
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  // Register
  Future<void> register(String email, String password, String role) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user == null) throw Exception('Registration failed');

      // Save user role to Supabase database
      await supabase.from('users').insert({
        'id': response.user!.id,
        'email': email,
        'role': role,
      });
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  // Password Reset
  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Password reset error: $e');
    }
  }
}