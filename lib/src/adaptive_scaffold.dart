import 'package:flutter/material.dart';
import '../src/responsive/responsive_helper.dart';

class AdaptiveScaffold extends StatefulWidget {
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
  final bool
      autoAdaptNavigation; // New parameter for controlling auto-adaptation

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
    this.autoAdaptNavigation = true, // Default to auto-adaptation
  });

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
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

    // Determine navigation style based on auto-adaptation setting
    final bool useNavigationRail = widget.navigationRailDestinations != null &&
        (widget.autoAdaptNavigation
            ? (isDesktop || isTablet || (isMobile && isLandscape))
            : true);

    return Scaffold(
      appBar: widget.appBar,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      body: Row(
        children: [
          if (useNavigationRail)
            NavigationRail(
              selectedIndex: widget.currentIndex,
              onDestinationSelected: widget.onTap,
              labelType: NavigationRailLabelType.selected,
              destinations: widget.navigationRailDestinations!,
            ),
          Expanded(
            child: Stack(
              children: [
                widget.body!,
                if (widget.floatingActionButton != null)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: widget.floatingActionButton!,
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.navigationRailDestinations != null &&
              (!useNavigationRail || !widget.autoAdaptNavigation)
          ? widget.bottomNavigationBar
          : null,
      bottomSheet: widget.bottomSheet,
    );
  }
}
