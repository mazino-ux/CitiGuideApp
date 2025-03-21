import 'package:flutter/material.dart';
import 'package:citi_guide_app/core/services/auth_service.dart';
import 'package:citi_guide_app/widgets/custom_button.dart';
import 'package:citi_guide_app/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  Future<void> _login() async {
    try {
      await _authService.login(
        _emailController.text,
        _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      // Navigate to home screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              key: const Key('emailField'),
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              key: const Key('passwordField'),
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgotPassword');
              },
              child: const Text('Forgot Password?'),
            ),
            const SizedBox(height: 40),
            CustomButton(
              key: const Key('loginButton'),
              text: 'Login',
              onPressed: _login,
            ),
          ],
        ),
      ),
    );
  }
}