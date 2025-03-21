import 'package:flutter/material.dart';
import 'package:citi_guide_app/core/services/auth_service.dart';
import 'package:citi_guide_app/widgets/custom_button.dart';
import 'package:citi_guide_app/widgets/custom_text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final _authService = AuthService();

  Future<void> _resetPassword() async {
    try {
      await _authService.resetPassword(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
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
            const SizedBox(height: 40),
            CustomButton(
              key: const Key('resetPasswordButton'),
              text: 'Reset Password',
              onPressed: _resetPassword,
            ),
          ],
        ),
      ),
    );
  }
}