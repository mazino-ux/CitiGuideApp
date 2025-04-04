import 'package:citi_guide_app/presentation/admin/screens/add_attraction_screen.dart';
import 'package:flutter/material.dart';
import 'quick_action_card.dart';
// import 'screens/add_attraction.dart';
// import 'screens/manage_users.dart';
// import 'screens/view_reports.dart';
// import 'screens/settings.dart';

class QuickActionsGrid extends StatelessWidget {
  QuickActionsGrid({super.key});

  final List<Map<String, dynamic>> actions = [
    {
      'title': 'Add Attraction',
      'icon': Icons.add_location_alt,
      'color': Colors.blue,
      'route': AddAttractionScreen(),
    },
    {
      'title': 'Manage Users',
      'icon': Icons.people,
      'color': Colors.green,
      // 'route': ManageUsersScreen(),
    },
    {
      'title': 'View Reports',
      'icon': Icons.bar_chart,
      'color': Colors.orange,
      // 'route': ViewReportsScreen(),
    },
    {
      'title': 'Settings',
      'icon': Icons.settings,
      'color': Colors.purple,
      // 'route': SettingsScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
        double childAspectRatio = constraints.maxWidth < 400 ? 1.2 : 1.5;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: actions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                return QuickActionCard(actions[index]);
              },
            ),
          ],
        );
      },
    );
  }
}
