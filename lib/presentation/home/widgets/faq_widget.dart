import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:citi_guide_app/presentation/home/faq/faq_page.dart';

class FAQWidget extends StatelessWidget {
  const FAQWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildFAQRow(
                  context,
                  icon: LucideIcons.map,
                  question: "How do I use the city map?",
                ),
                const Divider(height: 1, indent: 16),
                _buildFAQRow(
                  context,
                  icon: LucideIcons.star,
                  question: "How to save favorite places?",
                ),
                const Divider(height: 1, indent: 16),
                _buildFAQRow(
                  context,
                  icon: LucideIcons.clock,
                  question: "Are opening hours accurate?",
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Get.to(() => const FAQPage());

              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All FAQs',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFAQRow(BuildContext context, {required IconData icon, required String question}) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(
        question,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.deepPurple,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.deepPurple),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 24,
      dense: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FAQPage()),
        );
      },
    );
  }
}