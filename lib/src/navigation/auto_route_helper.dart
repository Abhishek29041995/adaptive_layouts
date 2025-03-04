import 'package:flutter/widgets.dart';

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
}
