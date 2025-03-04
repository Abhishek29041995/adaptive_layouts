import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class NavigationItem {
  final String title;
  final Widget icon; // Accepts any Widget (Icon or Image)
  final PageRouteInfo<dynamic>? autoRouteDestination; // For AutoRoute navigation
  final Widget? normalRouteDestination; // For normal navigation
  final VoidCallback? onTap; // Custom callback

  NavigationItem({
    required this.title,
    required this.icon,
    this.autoRouteDestination, // Used when AutoRoute is enabled
    this.normalRouteDestination, // Used for normal navigation
    this.onTap, // Custom logic if needed
  });
}
