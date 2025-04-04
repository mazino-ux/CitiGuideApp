import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, Admin',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 18 : 22,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Here\'s what\'s happening today',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(200),
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 24),
                onPressed: () {
                  // Add functionality (e.g., refresh data)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dashboard refreshed!')),
                  );
                },
                tooltip: 'Refresh',
              ),
            ],
          ),
        );
      },
    );
  }
}
