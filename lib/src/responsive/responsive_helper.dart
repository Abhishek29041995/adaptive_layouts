import 'package:flutter/material.dart';

enum Breakpoint { mobile, tablet, desktop, web, xl, xxl }

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= 480;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > 480 &&
      MediaQuery.of(context).size.width <= 800;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > 800 &&
      MediaQuery.of(context).size.width <= 1050;
  static bool isWeb(BuildContext context) =>
      MediaQuery.of(context).size.width > 1050 &&
      MediaQuery.of(context).size.width <= 1300;
  static bool isXL(BuildContext context) =>
      MediaQuery.of(context).size.width > 1300;

  static Breakpoint currentBreakpoint(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width <= 480) return Breakpoint.mobile;
    if (width <= 800) return Breakpoint.tablet;
    if (width <= 1050) return Breakpoint.desktop;
    if (width <= 1300) return Breakpoint.web;
    return Breakpoint.xxl;
  }
}
