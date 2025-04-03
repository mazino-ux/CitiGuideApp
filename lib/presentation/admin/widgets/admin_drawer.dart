import 'package:citi_guide_app/presentation/admin/admin_dashboard.dart';
import 'package:citi_guide_app/presentation/admin/screens/attractions.dart';
import 'package:citi_guide_app/presentation/home/home_screen.dart';
import 'package:flutter/material.dart';
// import 'dashboard_screen.dart';
// import 'attractions.dart';
// import 'users_screen.dart';
// import 'reviews_screen.dart';
// import 'settings_screen.dart';
// import 'help_screen.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  String selectedItem = 'Dashboard'; // Keeps track of the selected item

  void _navigateTo(BuildContext context, String title, Widget screen) {
    setState(() {
      selectedItem = title; // Update the selected item
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/admin_avatar.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  'Admin User',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'admin@cityguide.com',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary.withAlpha(230),
                  ),
                ),
              ],
            ),
          ),
          _DrawerItem(
            icon: Icons.home,
            title: 'Home',
            isSelected: selectedItem == 'Home',
            onTap: () => _navigateTo(context, 'Home', const HomeScreen()),
          ),
          _DrawerItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            isSelected: selectedItem == 'Dashboard',
            onTap: () => _navigateTo(context, 'Dashboard', const AdminDashboard()),
          ),
          _DrawerItem(
            icon: Icons.place,
            title: 'Attractions',
            isSelected: selectedItem == 'Attractions',
            onTap: () => _navigateTo(context, 'Attractions', const AttractionsScreen()),
          ),
          _DrawerItem(
            icon: Icons.reviews,
            title: 'Reviews',
            isSelected: selectedItem == 'Reviews',
            onTap: () => _navigateTo(context, 'Reviews', const AttractionsScreen()),
          ),
          _DrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            isSelected: selectedItem == 'Settings',
            onTap: () => _navigateTo(context, 'Settings', const AttractionsScreen()),
          ),
          const Divider(),
          _DrawerItem(
            icon: Icons.help,
            title: 'Help & Support',
            isSelected: selectedItem == 'Help & Support',
            onTap: () => _navigateTo(context, 'Help & Support', const AttractionsScreen()),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withAlpha(200),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      selected: isSelected,
      onTap: onTap,
    );
  }
}
