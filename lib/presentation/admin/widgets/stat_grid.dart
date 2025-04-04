import 'package:citi_guide_app/presentation/admin/widgets/stat_card.dart';
import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    List<StatCard> stats = const [
      StatCard(
        title: 'Total Visitors',
        value: '1,254',
        icon: Icons.people_alt,
        color: Colors.blue,
      ),
      StatCard(
        title: 'Attractions',
        value: '87',
        icon: Icons.place,
        color: Colors.green,
      ),
      StatCard(
        title: 'New Reviews',
        value: '32',
        icon: Icons.reviews,
        color: Colors.orange,
      ),
      StatCard(
        title: 'Revenue',
        value: '\$5,420',
        icon: Icons.attach_money,
        color: Colors.purple,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Small screens: Use ListView
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) => stats[index],
          );
        } else {
          // Larger screens: Use GridView
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constraints.maxWidth > 1000 ? 4 : 2, // Adjust grid dynamically
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
            ),
            itemBuilder: (context, index) => stats[index],
          );
        }
      },
    );
  }
}
