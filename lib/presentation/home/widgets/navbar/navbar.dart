import 'package:flutter/material.dart';
import 'package:citi_guide_app/presentation/home/widgets/navbar/navbar_items.dart';
import 'package:citi_guide_app/presentation/home/widgets/navbar/theme_toggle.dart';

class Navbar extends StatefulWidget {
  final bool isAdmin;

  const Navbar({super.key, required this.isAdmin});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("City Guide"),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        // Toggle Menu Button
        IconButton(
          icon: Icon(_isMenuOpen ? Icons.close : Icons.menu),
          onPressed: _toggleMenu,
        ),
        // Theme Toggle Button
        const ThemeToggle(),
      ],
      bottom: _isMenuOpen
          ? PreferredSize(
              preferredSize: const Size.fromHeight(200),
              child: NavbarItems(isAdmin: widget.isAdmin),
            )
          : null,
    );
  }
}
