import 'package:citi_guide_app/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Obx to rebuild when themeMode changes.
    return Obx(() {
      final themeController = ThemeController.to;
      return IconButton(
        icon: Icon(
          themeController.themeMode == ThemeMode.dark
              ? Icons.dark_mode
              : Icons.light_mode,
        ),
        onPressed: themeController.toggleTheme,
      );
    });
  }
}
