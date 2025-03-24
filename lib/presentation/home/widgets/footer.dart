import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:citi_guide_app/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          const Text(
            'City Guide App',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '© 2023 City Guide. All rights reserved.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.white),
                onPressed: () => _launchURL('https://www.facebook.com/CityGuideApp'),
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.twitter, color: Colors.white),
                onPressed: () => _launchURL('https://www.twitter.com/CityGuideApp'),
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.white),
                onPressed: () => _launchURL('https://www.instagram.com/CityGuideApp'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// Compare this snippet from lib/presentation/home/widgets/footer.dart: