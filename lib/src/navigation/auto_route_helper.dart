import 'package:flutter/widgets.dart';

/// Abstract class to ensure compatibility with or without `auto_route`.
abstract class AutoRouteHelper {
  static AutoRouteHelper get instance => _instance;

  void pushRoute(BuildContext context, dynamic route);
}

// Default instance (fallback)
AutoRouteHelper _instance = AutoRouteHelperFallback();
