// This file will be used when auto_route is not available.
import 'package:flutter/widgets.dart';
import 'auto_route_helper.dart';

class AutoRouteHelperImpl extends AutoRouteHelper {
  @override
  Widget wrapWithAutoTabsRouter({
    required List<PageRouteInfo> routes,
    required Widget Function(BuildContext, Widget, dynamic) builder,
  }) {
    // Fallback: Just return the first screen in routes
    return Builder(
      builder: (context) => builder(context, routes.first as Widget, null),
    );
  }
}
