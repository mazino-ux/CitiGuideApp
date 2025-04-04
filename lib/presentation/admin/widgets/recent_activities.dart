import 'package:flutter/material.dart';
import 'activity_item.dart';

class RecentActivities extends StatelessWidget {
  const RecentActivities({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> activities = [
      "Logged in",
      "Updated profile",
      "Completed a task",
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Activities',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 18 : 22,
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle "View All" action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('View all activities')),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                activities.isNotEmpty
                    ? SizedBox(
                        height: isSmallScreen ? 150 : 200, // Adjust height dynamically
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: activities.length,
                          itemBuilder: (context, index) {
                            return ActivityItem(index: index);
                          },
                        ),
                      )
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text('No recent activities.'),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
