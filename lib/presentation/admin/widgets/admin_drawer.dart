import 'package:citi_guide_app/presentation/admin/admin_dashboard.dart';
import 'package:citi_guide_app/presentation/admin/screens/cities_screen.dart'; // Add this import
import 'package:citi_guide_app/presentation/admin/screens/attractions.dart';
import 'package:citi_guide_app/presentation/home/home_screen.dart';
import 'package:flutter/material.dart';

class AdminDrawer extends StatefulWidget {
  final String? currentCityId; 

  const AdminDrawer({super.key, this.currentCityId});

  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  String selectedItem = 'Dashboard';

  void _navigateTo(BuildContext context, String title, Widget screen) {
    setState(() {
      selectedItem = title;
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
            icon: Icons.location_city,
            title: 'Cities',
            isSelected: selectedItem == 'Cities',
            onTap: () => _navigateTo(context, 'Cities', const CitiesScreen()),
          ),
          _DrawerItem(
            icon: Icons.place,
            title: 'Attractions',
            isSelected: selectedItem == 'Attractions',
            onTap: () {
              if (widget.currentCityId != null) {
                _navigateTo(
                  context, 
                  'Attractions', 
                  AttractionsScreen(cityId: widget.currentCityId!)
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a city first')),
                );
                // Optionally navigate to CitiesScreen
                _navigateTo(context, 'Cities', const CitiesScreen());
              }
            },
          ),
          _DrawerItem(
            icon: Icons.reviews,
            title: 'Reviews',
            isSelected: selectedItem == 'Reviews',
            onTap: () {
              // You'll need to implement ReviewsScreen
              // _navigateTo(context, 'Reviews', const ReviewsScreen());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reviews screen coming soon')),
              );
            },
          ),
          _DrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            isSelected: selectedItem == 'Settings',
            onTap: () {
              // You'll need to implement SettingsScreen
              // _navigateTo(context, 'Settings', const SettingsScreen());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings screen coming soon')),
              );
            },
          ),
          const Divider(),
          _DrawerItem(
            icon: Icons.help,
            title: 'Help & Support',
            isSelected: selectedItem == 'Help & Support',
            onTap: () {
              // You'll need to implement HelpScreen
              // _navigateTo(context, 'Help & Support', const HelpScreen());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help screen coming soon')),
              );
            },
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