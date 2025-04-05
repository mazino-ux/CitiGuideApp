import 'package:citi_guide_app/presentation/admin/admin_dashboard.dart';
import 'package:citi_guide_app/presentation/admin/screens/attractions.dart';
import 'package:citi_guide_app/presentation/admin/screens/cities_screen.dart';
import 'package:citi_guide_app/presentation/auth/forgot_password.dart';
import 'package:citi_guide_app/presentation/auth/login_screen.dart';
import 'package:citi_guide_app/presentation/auth/onboarding_screen.dart';
import 'package:citi_guide_app/presentation/auth/register_screen.dart';
import 'package:citi_guide_app/presentation/auth/role_selection_screen.dart';
import 'package:citi_guide_app/presentation/home/home_screen.dart';
import 'package:get/get.dart';

class Routes {
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/roleSelection';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgotPassword';
  static const String home = '/home';
  static const String adminDashboard = '/dashboard';
}

class AppRoutes {
  static final pages = [
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.roleSelection,
      page: () => const RoleSelectionScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.register,
      page: () => RegisterScreen(role: Get.arguments ?? 'user'),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPassword(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: Routes.adminDashboard,
      page: () => const AdminDashboard(),
      transition: Transition.fadeIn,
    ),
        // Update your router to include the CitiesScreen
    GetPage(
      name: '/admin/cities',
      page: () => const CitiesScreen(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: '/admin/attractions',
      page: () => AttractionsScreen(cityId: Get.arguments),
      transition: Transition.rightToLeft,
    ),
  ];
}