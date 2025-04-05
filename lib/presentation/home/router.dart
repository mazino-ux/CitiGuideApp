import 'package:citi_guide_app/presentation/admin/admin_dashboard.dart';
import 'package:citi_guide_app/presentation/explore/explore_screen.dart';
import 'package:get/get.dart';

// Import screens
import 'home_screen.dart';
// import 'screens/favorites_screen.dart';
// import 'screens/profile_screen.dart';

class HomeRoutes {
  static final routes = <GetPage>[
    GetPage(
      name: '/home',
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/explore',
      page: () => const ExploreScreen(cities: [],),
      transition: Transition.rightToLeft,
    ),
    // GetPage(
    //   name: '/favorites',
    //   page: () => const FavoritesScreen(),
    //   transition: Transition.downToUp,
    // ),
    // GetPage(
    //   name: '/profile',
    //   page: () => const ProfileScreen(),
    //   transition: Transition.zoom,
    // ),
    GetPage(
      name: '/dashboard',
      page: () => const AdminDashboard(),
      transition: Transition.leftToRightWithFade,
    ),
  ];
}
