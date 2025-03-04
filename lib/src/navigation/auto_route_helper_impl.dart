import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'auto_route_helper.dart';

// Use `auto_route` when available
AutoRouteHelper _instance = AutoRouteHelperImpl();

class AutoRouteHelperImpl extends AutoRouteHelper {
  @override
  void pushRoute(BuildContext context, dynamic route) {
    if (route is PageRouteInfo) {
      AutoRouter.of(context).push(route);
    }
  }
}
