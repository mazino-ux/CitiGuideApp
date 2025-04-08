import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine screen width to decide layout & scale factor.
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1100;
    final bool isDesktop = screenWidth >= 1100;

    // Scale factor: mobile uses full size; tablet & desktop use smaller scale.
    final double scaleFactor = isMobile ? 1.0 : (isTablet ? 0.8 : 0.65);

    // For tablet/desktop, use horizontal layout.
    Widget roleCardsLayout;
    if (isMobile) {
      roleCardsLayout = Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: _RoleCard(
                title: 'User/Tourist',
                icon: Icons.explore_rounded,
                description:
                    'Explore attractions and get personalized recommendations',
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(75, 186, 104, 200),
                    Color.fromARGB(70, 223, 64, 251),
                  ],
                ),
                onTap: () =>
                    Navigator.pushNamed(context, '/register', arguments: 'user'),
                scaleFactor: scaleFactor,
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: _RoleCard(
                title: 'Admin',
                icon: Icons.admin_panel_settings_rounded,
                description: 'Manage attractions and content for the platform',
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(63, 68, 137, 255),
                    Color.fromARGB(64, 64, 195, 255),
                  ],
                ),
                onTap: () => Navigator.pushNamed(context, '/register',
                    arguments: 'admin'),
                scaleFactor: scaleFactor,
              ),
            ),
          ],
        ),
      );
    } else {
      roleCardsLayout = Padding(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100.w : 30.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _RoleCard(
                title: 'User/Tourist',
                icon: Icons.explore_rounded,
                description:
                    'Explore attractions and get personalized recommendations',
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(75, 186, 104, 200),
                    Color.fromARGB(70, 223, 64, 251),
                  ],
                ),
                onTap: () =>
                    Navigator.pushNamed(context, '/register', arguments: 'user'),
                scaleFactor: scaleFactor,
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: _RoleCard(
                title: 'Admin',
                icon: Icons.admin_panel_settings_rounded,
                description: 'Manage attractions and content for the platform',
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(63, 68, 137, 255),
                    Color.fromARGB(64, 64, 195, 255),
                  ],
                ),
                onTap: () => Navigator.pushNamed(context, '/register',
                    arguments: 'admin'),
                scaleFactor: scaleFactor,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[900]!, Colors.grey[850]!],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.purple[300]!, Colors.purpleAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: Text(
                      'Join as',
                      style: TextStyle(
                        fontSize: isDesktop ? 10.sp : 22.sp * scaleFactor,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  roleCardsLayout,
                  SizedBox(height: 40.h),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        side: BorderSide(
                            color: Colors.white.withAlpha(128), width: 1.5),
                      ),
                    ),
                    child: Text(
                      'Already have an account? Log in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isDesktop ? 6.sp : 12.sp * scaleFactor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final Gradient gradient;
  final VoidCallback onTap;
  final double scaleFactor;

  const _RoleCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.gradient,
    required this.onTap,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20.r * scaleFactor),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r * scaleFactor),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(24 * scaleFactor),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r * scaleFactor),
            gradient: gradient,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(76),
                blurRadius: 20 * scaleFactor,
                spreadRadius: 2 * scaleFactor,
                offset: Offset(0, 10 * scaleFactor),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80 * scaleFactor,
                height: 80 * scaleFactor,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40 * scaleFactor,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20 * scaleFactor),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22 * scaleFactor,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12 * scaleFactor),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15 * scaleFactor,
                  color: Colors.white.withAlpha(204),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10 * scaleFactor),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white.withAlpha(180),
                size: 24 * scaleFactor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
