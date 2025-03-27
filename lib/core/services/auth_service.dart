import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Login user with email and password (Auto-login after signup) 
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (response.user == null) {
        return {'success': false, 'message': 'User not found.'};
      }

      return {'success': true, 'user': response.user};
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('invalid login credentials')) {
        return {'success': false, 'message': 'Incorrect Details!.'};
      } else if (e.message.toLowerCase().contains('user not found')) {
        return {'success': false, 'message': 'User not found.'};
      }
      return {'success': false, 'message': 'Login error: ${e.message}'};
    } catch (e) {
      return {'success': false, 'message': 'Login error: ${e.toString()}'};
    }
  }


  // Register a new user (Auto-login after signup)
  Future<Map<String, dynamic>> register({
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
        return {'success': false, 'message': 'Registration failed. Try again.'};
      }

      // Insert user details into the 'profiles' table
      await supabase.from('profiles').insert({
        'id': authResponse.user!.id,
        'email': email.trim(),
        'name': name.trim(),
        'role': role.toLowerCase(),
        'created_at': DateTime.now().toIso8601String(),
      });

      // Auto-login the user immediately after registration
      final loginResponse = await login(email, password);
      return loginResponse;
    } on AuthException catch (e) {
      return {'success': false, 'message': 'Registration error: ${e.message}'};
    } catch (e) {
      return {'success': false, 'message': 'Registration error: ${e.toString()}'};
    }
  }

  // Register method for legacy systems
  Future<Map<String, dynamic>> registerLegacy(String email, String password, String role, {String? name}) async {
    return register(
      email: email,
      password: password,
      role: role,
      name: name ?? 'User',
    );
  }

  // Send password reset email
   Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email.trim());

      return {'success': true, 'message': 'Reset link sent successfully'};
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('user not found')) {
        return {'success': false, 'message': 'No account found with this email.'};
      }
      return {'success': false, 'message': 'Error: ${e.message}'};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred.'};
    }
  }

  // Get current user session
  User? get currentUser => supabase.auth.currentUser;

  // Sign out user
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign out error: ${e.toString()}');
    }
  }
}
