import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

abstract class AutoRouteHelper {
  static AutoRouteHelper? _instance;

  static AutoRouteHelper get instance {
    if (_instance == null) {
      throw Exception("AutoRouteHelper implementation is not set.");
    }
    return _instance!;
  }

  static void setImplementation(AutoRouteHelper implementation) {
    _instance = implementation;
  }

  void pushRoute(BuildContext context, dynamic route);

  /// Wraps with AutoTabsRouter for auto_route navigation.
  Widget wrapWithAutoTabsRouter({
    required List<PageRouteInfo> routes,
    required Widget Function(BuildContext, Widget, TabsRouter) builder,
  });
}
