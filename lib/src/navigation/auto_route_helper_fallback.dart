import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../navigation/auto_route_helper.dart';

class AutoRouteHelperFallback extends AutoRouteHelper {
  AutoRouteHelperFallback() {
    AutoRouteHelper.setImplementation(this);
  }

  @override
  void pushRoute(BuildContext context, dynamic route) {
    if (route is Widget) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => route));
    } else if (route is String) {
      Navigator.of(context).pushNamed(route);
    } else {
      throw Exception("Unsupported route type: ${route.runtimeType}");
    }
  }

  @override
  Widget wrapWithAutoTabsRouter(
      {required List routes,
      required Widget Function(BuildContext p1, Widget p2, TabsRouter p3)
          builder}) {
    // Since we don't have AutoTabsRouter, use a basic PageView to mimic behavior.
    return Builder(
      builder: (context) {
        return PageView(
          children: routes.map((route) {
            if (route is Widget) {
              return route;
            } else {
              return Container(); // Fallback for unsupported types
            }
          }).toList(),
        );
      },
    );
  }
}
