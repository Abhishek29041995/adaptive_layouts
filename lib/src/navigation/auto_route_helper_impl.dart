// This file will only be used if auto_route is available.
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'auto_route_helper.dart';

class AutoRouteHelperImpl extends AutoRouteHelper {
  @override
  Widget wrapWithAutoTabsRouter({
    required List<PageRouteInfo> routes,
    required Widget Function(BuildContext, Widget, TabsRouter) builder,
  }) {
    return AutoTabsRouter(routes: routes, builder: builder);
  }
}
