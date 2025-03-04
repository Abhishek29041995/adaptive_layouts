import 'package:flutter/widgets.dart';

/// Abstract class to support both `auto_route` and normal `Navigator` routes.
class NavigationItem {
  final String label;
  final Widget icon;
  final VoidCallback? onTap;
  final Widget? normalRouteDestination;
  final dynamic
      autoRouteDestination; // Keep it dynamic to avoid dependency issues

  NavigationItem({
    required this.label,
    required this.icon,
    this.onTap,
    this.normalRouteDestination,
    this.autoRouteDestination,
  });
}
