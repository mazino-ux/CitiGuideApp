import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:citi_guide_app/core/theme/theme_provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return IconButton(
      icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
      onPressed: () {
        themeProvider.toggleTheme(true);
      },
    );
  }
}
