import 'package:citi_guide_app/presentation/admin/widgets/stat_card.dart';
import 'package:flutter/material.dart';
// import 'stat_card.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: const [
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
      ],
    );
  }
}
