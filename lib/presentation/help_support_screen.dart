import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.help_center_rounded,
                        size: 60.w,
                        color: Colors.white,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Help & Support',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(24.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionTitle('Need Assistance?', theme),
                SizedBox(height: 16.h),
                Text(
                  "We're here to help you make the most of your city exploration. "
                  "Contact us through any of the channels below:",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(200),
                  ),
                ),
                SizedBox(height: 32.h),
                _buildSectionTitle('Contact Options', theme),
                SizedBox(height: 16.h),
                _buildContactCard(
                  context,
                  icon: FontAwesomeIcons.envelope,
                  title: 'Email Support',
                  subtitle: 'Get quick answers via email',
                  value: 'mazinoishioma@gmail.com',
                  onTap: () => _launchEmail('mazinoishioma@gmail.com'),
                ),
                SizedBox(height: 16.h),
                _buildContactCard(
                  context,
                  icon: FontAwesomeIcons.phone,
                  title: 'Call Support',
                  subtitle: 'Speak directly with our team',
                  value: '+234 805 996 9404',
                  onTap: () => _launchPhoneCall('+2348059969404'),
                ),
                SizedBox(height: 16.h),
                _buildContactCard(
                  context,
                  icon: FontAwesomeIcons.whatsapp,
                  title: 'WhatsApp Chat',
                  subtitle: 'Instant messaging support',
                  value: '+234 805 996 9404',
                  onTap: () => _launchWhatsApp('+2348059969404'),
                ),
                SizedBox(height: 32.h),
                _buildSectionTitle('Frequently Asked Questions', theme),
                SizedBox(height: 16.h),
                _buildFAQItem(
                  context,
                  question: 'How do I report incorrect attraction information?',
                  answer: 'Please email us with the attraction name and details of the correction needed.',
                ),
                SizedBox(height: 12.h),
                _buildFAQItem(
                  context,
                  question: 'Is the app available in multiple languages?',
                  answer: 'Currently we support English, with more languages coming soon!',
                ),
                SizedBox(height: 12.h),
                _buildFAQItem(
                  context,
                  question: 'How often is the attraction data updated?',
                  answer: 'Our database is updated weekly with new attractions and information.',
                ),
                SizedBox(height: 40.h),
                Center(
                  child: Text(
                    'We typically respond within 24 hours',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 24.w,
                ),
              ),
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
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    final theme = Theme.of(context);
    
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      title: Text(
        question,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
          child: Text(
            answer,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(200),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchPhoneCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final uri = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}