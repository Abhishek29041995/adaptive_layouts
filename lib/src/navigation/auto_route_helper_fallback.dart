import 'package:flutter/material.dart';
import 'auto_route_helper.dart';

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
}
