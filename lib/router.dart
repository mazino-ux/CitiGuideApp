import 'package:flutter/material.dart';
import 'package:citi_guide_app/presentation/home/home_screen.dart';
// import 'package:citi_guide_app/presentation/screens/home_screen.dart';
// import 'package:citi_guide_app/presentation/screens/explore_screen.dart';
// import 'package:citi_guide_app/presentation/screens/favorites_screen.dart';
// import 'package:citi_guide_app/presentation/screens/profile_screen.dart';
// import 'package:citi_guide_app/presentation/screens/admin_dashboard.dart';

Map<String, WidgetBuilder> appRoutes = {
  "/home": (context) => const HomeScreen(),
  // "/explore": (context) => const ExploreScreen(),
  // "/favorites": (context) => const FavoritesScreen(),
  // "/profile": (context) => const ProfileScreen(),
  // "/admin": (context) => const AdminDashboard(),
};
