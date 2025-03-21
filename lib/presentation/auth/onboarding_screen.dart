import 'package:citi_guide_app/presentation/auth/register_screen.dart';
import 'package:citi_guide_app/widgets/onboarding_option_card.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to City Guide',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            OnboardingOptionCard(
              title: 'User/Tourist',
              subtitle: 'Explore the city as a user or tourist',
              icon: Icons.person,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(role: 'user'),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            OnboardingOptionCard(
              title: 'Admin',
              subtitle: 'Manage attractions and content',
              icon: Icons.admin_panel_settings,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(role: 'admin'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}