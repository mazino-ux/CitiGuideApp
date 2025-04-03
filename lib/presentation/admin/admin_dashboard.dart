import 'package:flutter/material.dart';

import 'widgets/admin_drawer.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/quick_action_grid.dart';
import 'widgets/recent_activities.dart';
import 'widgets/stat_grid.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DashboardHeader(),
            const SizedBox(height: 20),
            const StatsGrid(),
            const SizedBox(height: 20),
            const RecentActivities(),
            const SizedBox(height: 20),
            QuickActionsGrid(),
          ],
        ),
      ),
    );
  }
}