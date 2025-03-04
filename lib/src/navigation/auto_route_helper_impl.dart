import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'auto_route_helper.dart';

class AutoRouteHelperImpl extends AutoRouteHelper {
  AutoRouteHelperImpl() {
    AutoRouteHelper.setImplementation(this);
  }

  @override
  void pushRoute(BuildContext context, dynamic route) {
    if (route is PageRouteInfo) {
      AutoRouter.of(context).push(route);
    } else if (route is Widget) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => route));
    } else if (route is String) {
      Navigator.of(context).pushNamed(route);
    } else {
      throw Exception("Unsupported route type: ${route.runtimeType}");
    }
  }

  @override
  Widget wrapWithAutoTabsRouter({
    required List routes,
    required Widget Function(BuildContext, Widget, TabsRouter) builder,
  }) {
    return AutoTabsRouter(
      routes: routes as List<PageRouteInfo>,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return builder(context, child, tabsRouter);
      },
    );
  }
}
