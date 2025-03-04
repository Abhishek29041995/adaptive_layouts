import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'auto_route_helper.dart';

class AutoRouteHelperImpl extends AutoRouteHelper {
  AutoRouteHelperImpl() {
    AutoRouteHelper.setImplementation(this);
  }

  @override
  Widget wrapWithAutoTabsRouter({
    required List<PageRouteInfo> routes,
    required Widget Function(BuildContext, Widget, TabsRouter) builder,
  }) {
    return AutoTabsRouter(routes: routes, builder: builder);
  }

  @override
  void setActiveIndex(BuildContext context, int index) {
    AutoTabsRouter.of(context).setActiveIndex(index);
  }

  @override
  int getActiveIndex(BuildContext context) {
    return AutoTabsRouter.of(context).activeIndex;
  }
}
