import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'navbar_items.dart';
import 'theme_toggle.dart';

class Navbar extends StatelessWidget {
  final bool isAdmin;
  const Navbar({super.key, required this.isAdmin});

  // Breakpoints: mobile <600, tablet 600-1099, desktop >=1100
  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 1100;

  void _openMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      builder: (_) => NavbarItems(isAdmin: isAdmin, isMobile: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < mobileBreakpoint;
    final bool isTablet =
        width >= mobileBreakpoint && width < desktopBreakpoint;

    if (isMobile) {
      return AppBar(
        title: _buildTitle(isMobile: true),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.menu, size: 24.sp),
          onPressed: () => _openMobileMenu(context),
        ),
        actions: const [ThemeToggle()],
      );
    } else {
      // Tablet & Desktop: a combined AppBar with title and navigation items.
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Row(
          children: [
            _buildTitle(isMobile: false),
            SizedBox(width: 20.w),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: NavbarItems(
                  isAdmin: isAdmin,
                  isMobile: false,
                  isTablet: isTablet,
                ),
              ),
            ),
          ],
        ),
        actions: [
          const ThemeToggle(),
          if (isAdmin)
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Icon(Icons.verified_user, color: Colors.green),
            ),
        ],
      );
    }
  }

  Widget _buildTitle({required bool isMobile}) {
    return Text(
      "City Guide",
      style: TextStyle(
        fontSize: isMobile ? 20.sp : 7.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
