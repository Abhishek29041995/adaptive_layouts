// This file wraps auto_route to avoid direct dependency issues.
import 'package:flutter/widgets.dart';

/// Abstract class to ensure a consistent API.
abstract class AutoRouteHelper {
  Widget wrapWithAutoTabsRouter({
    required List<PageRouteInfo> routes,
    required Widget Function(BuildContext, Widget, TabsRouter) builder,
  });
}
