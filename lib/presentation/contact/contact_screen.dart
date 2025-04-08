import 'package:citi_guide_app/presentation/home/widgets/navbar/navbar_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'navbar_items.dart';

class ContactScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cities;
  final bool isAdmin;

  const ContactScreen({
    super.key,
    required this.cities,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'We\'d love to hear from you!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _ContactCard(
                    icon: Icons.email_rounded,
                    title: 'Email Us',
                    subtitle: 'support@cityguide.com',
                    onTap: () {
                      // Implement email functionality
                    },
                  ),
                  SizedBox(height: 16.h),
                  _ContactCard(
                    icon: Icons.phone_rounded,
                    title: 'Call Us',
                    subtitle: '+234 810 469 4214',
                    onTap: () {
                      // Implement phone call functionality
                    },
                  ),
                  SizedBox(height: 16.h),
                  _ContactCard(
                    icon: Icons.location_on_rounded,
                    title: 'Visit Us',
                    subtitle: '123 City Guide St, Urban Center',
                    onTap: () {
                      // Implement maps functionality
                    },
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    'Send us a message',
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Your Name',
                      prefixIcon: Icon(Icons.person_rounded),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Your Email',
                      prefixIcon: Icon(Icons.email_rounded),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Message',
                      prefixIcon: Icon(Icons.message_rounded),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement send message functionality
                      },
                      child: const Text('Send Message'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Footer
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withAlpha(50),
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withAlpha(50),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                      icon: const FaIcon(FontAwesomeIcons.facebook),
                      onPressed: () async {
                        final url = Uri.parse('https://www.facebook.com/CityGuideApp');
                        if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                        }
                      },
                      ),
                      IconButton(
                      icon: const FaIcon(FontAwesomeIcons.twitter),
                      onPressed: () async {
                        final url = Uri.parse('https://www.twitter.com/CityGuideApp');
                        if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                        }
                      },
                      ),
                      IconButton(
                      icon: const FaIcon(FontAwesomeIcons.instagram),
                      onPressed: () async {
                        final url = Uri.parse('https://www.instagram.com/CityGuideApp');
                        if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                        }
                      },
                      ),
                    ],
                ),
                SizedBox(height: 12.h),
                Text(
                  '© 2023 City Guide App. All rights reserved.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withAlpha(150),
                  ),
                ),
                if (isMobile) ...[
                  SizedBox(height: 16.h),
                  NavbarItems(
                    isAdmin: isAdmin,
                    isMobile: false,
                    cities: cities,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.dividerColor.withAlpha(50),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Icon(icon, size: 28.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withAlpha(150),
              ),
            ],
          ),
        ),
      ),
    );
  }
}