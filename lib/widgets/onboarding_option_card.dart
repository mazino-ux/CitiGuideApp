import 'package:flutter/material.dart';

class OnboardingOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  // final Key? key;

  const OnboardingOptionCard({super.key, 
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    // this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(subtitle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}