import 'package:flutter/material.dart';

class NavbarItems extends StatelessWidget {
  final bool isAdmin;

  const NavbarItems({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          _buildNavItem(Icons.home, "Home", () => _navigate(context, "/home")),
          _buildNavItem(Icons.map, "Explore", () => _navigate(context, "/explore")),
          _buildNavItem(Icons.favorite, "Favorites", () => _navigate(context, "/favorites")),
          _buildNavItem(Icons.person, "Profile", () => _navigate(context, "/profile")),
          if (isAdmin) _buildNavItem(Icons.dashboard, "Admin Dashboard", () => _navigate(context, "/admin")),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      onTap: onTap,
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }
}
