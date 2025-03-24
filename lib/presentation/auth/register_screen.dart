import 'package:flutter/material.dart';
import 'package:citi_guide_app/core/services/auth_service.dart';
import 'package:citi_guide_app/widgets/custom_button.dart';
import 'package:citi_guide_app/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  final String role;

  const RegisterScreen({super.key, required this.role});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  Future<void> _register() async {
    try {
      await _authService.register(
        _emailController.text,
        _passwordController.text,
        widget.role,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
      Navigator.pushNamed(context, '/login'); // Go back to login screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register as ${widget.role}')),
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
            const SizedBox(height: 40),
            CustomButton(
              key: const Key('registerButton'),
              text: 'Register',
              onPressed: _register,
            ),
          ],
        ),
      ),
    );
  }
}