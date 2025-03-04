import 'package:flutter/widgets.dart';
import 'auto_route_helper.dart';

class AutoRouteHelperImpl extends AutoRouteHelper {
  AutoRouteHelperImpl() {
    AutoRouteHelper.setImplementation(this);
  }

  @override
  Widget wrapWithAutoTabsRouter({
    required List<PageRouteInfo> routes,
    required Widget Function(BuildContext, Widget, dynamic) builder,
  }) {
    return Builder(
      builder: (context) => builder(context, const SizedBox(), null),
    );
  }

  @override
  void setActiveIndex(BuildContext context, int index) {}

  @override
  int getActiveIndex(BuildContext context) => 0;
}
