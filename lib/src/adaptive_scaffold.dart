import 'package:flutter/material.dart';
import '../src/responsive/responsive_helper.dart';

class AdaptiveScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomSheet;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final List<NavigationRailDestination>? navigationRailDestinations;
  final ValueChanged<int>? onTap;
  final int currentIndex;

  const AdaptiveScaffold({
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.drawer,
    this.endDrawer,
    this.bottomSheet,
    required this.body,
    this.bottomNavigationBar,
    this.navigationRailDestinations,
    this.onTap,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final breakpoint = Responsive.currentBreakpoint(context);
    final bool isTablet = breakpoint == Breakpoint.tablet;
    final bool isMobile = breakpoint == Breakpoint.mobile;
    final bool isDesktop = breakpoint == Breakpoint.desktop ||
        breakpoint == Breakpoint.web ||
        breakpoint == Breakpoint.xl ||
        breakpoint == Breakpoint.xxl;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: appBar,
      drawer: !isDesktop ? drawer : null,
      endDrawer: !isDesktop ? endDrawer : null,
      body: Stack(
        children: [
          Row(
            children: [
              if (isDesktop && drawer != null)
                SizedBox(width: 250, child: drawer),
              if ((isTablet || (isMobile && isLandscape)) &&
                  navigationRailDestinations != null)
                NavigationRail(
                  selectedIndex: currentIndex,
                  onDestinationSelected: onTap,
                  labelType: NavigationRailLabelType.selected,
                  destinations: navigationRailDestinations!,
                ),
              Expanded(child: body!),
              if (isDesktop && endDrawer != null)
                SizedBox(width: 250, child: endDrawer),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: floatingActionButton ?? const SizedBox.shrink(),
          ),
        ],
      ),
      bottomNavigationBar: (!isDesktop && !(isTablet && isLandscape))
          ? bottomNavigationBar
          : null,
      bottomSheet: bottomSheet,
    );
  }
}
