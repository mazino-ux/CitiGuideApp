import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavbarItems extends StatelessWidget {
  final bool isAdmin;
  final bool isMobile;
  final bool isTablet;

  const NavbarItems({
    super.key,
    required this.isAdmin,
    required this.isMobile,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildNavItems(context),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildNavItems(context),
          );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    final List<Widget> items = [
      _NavItem(
        icon: Icons.home,
        label: "Home",
        route: "/home",
        isMobile: isMobile,
      ),
      SizedBox(width: 8.w),
      _NavItem(
        icon: Icons.map,
        label: "Explore",
        route: "/explore",
        isMobile: isMobile,
      ),
      SizedBox(width: 8.w),
      _NavItem(
        icon: Icons.favorite,
        label: "Favorites",
        route: "/favorites",
        isMobile: isMobile,
      ),
      SizedBox(width: 8.w),
      _NavItem(
        icon: Icons.person,
        label: "Profile",
        route: "/profile",
        isMobile: isMobile,
      ),
    ];

    if (isAdmin) {
      items.add(SizedBox(width: 8.w));
      items.add(
        _NavItem(
          icon: Icons.dashboard,
          label: isTablet ? "Admin" : "Admin Dashboard",
          route: '/dashboard',
          isMobile: isMobile,
          isHighlighted: true,
        ),
      );
    }
    return items;
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isMobile;
  final bool isHighlighted;

  const _NavItem({
    // super.key,
    required this.icon,
    required this.label,
    required this.route,
    this.isMobile = false,
    this.isHighlighted = false,
  });

  void _navigate(BuildContext context) {
    Navigator.pushNamed(context, route);
    if (isMobile) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? ListTile(
            leading: Icon(icon, size: 24.sp),
            title: Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onTap: () => _navigate(context),
          )
        : TextButton.icon(
            onPressed: () => _navigate(context),
            icon: Icon(icon, size: 7.sp, color: Colors.white),
            label: Text(
              label,
              style: TextStyle(
                fontSize: 5.sp,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: Colors.white,
              ),
            ),
          );
  }
}
