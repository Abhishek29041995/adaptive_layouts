import 'package:flutter/widgets.dart';

/// Abstract class to ensure a consistent API.
abstract class AutoRouteHelper {
  static AutoRouteHelper get instance => _instance;
  static late AutoRouteHelper _instance;

  static void setImplementation(AutoRouteHelper implementation) {
    _instance = implementation;
  }

  Widget wrapWithAutoTabsRouter({
    required List<PageRouteInfo> routes,
    required Widget Function(BuildContext, Widget, dynamic) builder,
  });

  void setActiveIndex(BuildContext context, int index) {}

  int getActiveIndex(BuildContext context) => 0;
}
