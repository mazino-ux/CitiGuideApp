import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();
  
  final GetStorage _storage = GetStorage();
  
  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;
  
  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    final String? savedTheme = _storage.read('themeMode');
    if (savedTheme != null) {
      _themeMode.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }
  }

  /// Toggle the theme and persist the change.
  void toggleTheme() {
    final bool isDark = _themeMode.value == ThemeMode.light;
    final newTheme = isDark ? ThemeMode.dark : ThemeMode.light;
    _themeMode.value = newTheme;
    _storage.write('themeMode', isDark ? 'dark' : 'light');

    // ✅ This will notify GetX to update the theme globally
    Get.changeThemeMode(newTheme);
  }
}
