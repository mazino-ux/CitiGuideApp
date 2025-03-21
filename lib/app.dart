import 'package:citi_guide_app/presentation/auth/forgot_password.dart';
import 'package:citi_guide_app/presentation/auth/login_screen.dart';
import 'package:citi_guide_app/presentation/auth/onboarding_screen.dart';
import 'package:citi_guide_app/presentation/auth/register_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/onboarding',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/onboarding':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          case '/login':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          case '/register':
            final role = settings.arguments as String;
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => RegisterScreen(role: role),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          case '/forgotPassword':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => ForgotPassword(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          default:
            return MaterialPageRoute(builder: (context) => const OnboardingScreen());
        }
      },
    );
  }
}