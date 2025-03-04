import 'package:flutter/widgets.dart';
import 'auto_route_helper.dart';

// Fallback when `auto_route` is missing
class AutoRouteHelperFallback extends AutoRouteHelper {
  @override
  void pushRoute(BuildContext context, dynamic route) {
    debugPrint("AutoRoute not available. Cannot navigate to: $route");
  }
}
