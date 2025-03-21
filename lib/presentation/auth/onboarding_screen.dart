import 'package:flutter/material.dart';
import 'package:citi_guide_app/widgets/onboarding_option_card.dart';

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
            const Text(
              'Welcome to City Guide',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            OnboardingOptionCard(
              key: const Key('userOption'),
              title: 'User/Tourist',
              subtitle: 'Explore the city as a user or tourist',
              icon: Icons.person,
              onTap: () {
                Navigator.pushNamed(context, '/register', arguments: 'user');
              },
            ),
            const SizedBox(height: 20),
            OnboardingOptionCard(
              key: const Key('adminOption'),
              title: 'Admin',
              subtitle: 'Manage attractions and content',
              icon: Icons.admin_panel_settings,
              onTap: () {
                Navigator.pushNamed(context, '/register', arguments: 'admin');
              },
            ),
          ],
        ),
      ),
    );
  }
}