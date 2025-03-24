import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Login with email and password
  Future<User?> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      if (response.user == null) {
        throw Exception('Login failed - No user returned');
      }
      
      return response.user;
    } on AuthException catch (e) {
      throw Exception('Login error: ${e.message}');
    } catch (e) {
      throw Exception('Login error: ${e.toString()}');
    }
  }

  // New version with named parameters (recommended)
  Future<User?> register({
    required String email,
    required String password,
    required String role,
    required String name,
  }) async {
    try {
      final authResponse = await supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
        data: {'name': name.trim()},
      );

      if (authResponse.user == null) {
        throw Exception('Registration failed - No user returned');
      }

      await supabase.from('profiles').insert({
        'id': authResponse.user!.id,
        'email': email.trim(),
        'name': name.trim(),
        'role': role.toLowerCase(),
        'created_at': DateTime.now().toIso8601String(),
      });

      return authResponse.user;
    } on AuthException catch (e) {
      throw Exception('Registration error: ${e.message}');
    } catch (e) {
      throw Exception('Registration error: ${e.toString()}');
    }
  }

  // Legacy version for backward compatibility
  Future<User?> registerLegacy(String email, String password, String role, {String? name}) async {
    return register(
      email: email,
      password: password,
      role: role,
      name: name ?? 'User', // Default name if not provided
    );
  }

  // Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: 'app.citiguide.com/reset-password',
      );
    } on AuthException catch (e) {
      throw Exception('Password reset error: ${e.message}');
    } catch (e) {
      throw Exception('Password reset error: ${e.toString()}');
    }
  }

  // Get current user session
  User? get currentUser => supabase.auth.currentUser;

  // Sign out
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign out error: ${e.toString()}');
    }
  }
}