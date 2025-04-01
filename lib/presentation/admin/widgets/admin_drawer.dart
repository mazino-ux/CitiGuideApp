import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

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
                    color: Theme.of(context).colorScheme.onPrimary..withAlpha(230),
                  ),
                ),
              ],
            ),
          ),
          _DrawerItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            onTap: () {},
            isSelected: true,
          ),
          _DrawerItem(
            icon: Icons.place,
            title: 'Attractions',
            onTap: () {},
          ),
          _DrawerItem(
            icon: Icons.people,
            title: 'Users',
            onTap: () {},
          ),
          _DrawerItem(
            icon: Icons.reviews,
            title: 'Reviews',
            onTap: () {},
          ),
          _DrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {},
          ),
          const Divider(),
          _DrawerItem(
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {},
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