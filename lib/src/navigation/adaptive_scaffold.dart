import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../navigation/navigation_item.dart';
import '../navigation_mode.dart';
import '../responsive/responsive_helper.dart';
import '../navigation/adaptive_navigation.dart';
import '../navigation/auto_route_helper.dart';

class AdaptiveScaffold extends StatefulWidget {
  final List<NavigationItem> destinations;
  final AdaptiveNavigationMode navigationMode;
  final String title;
  final bool useAutoRoute;
  final GlobalKey<NavigatorState>? navigatorKey;
  final Widget? body; // ✅ Replaced `child` with `body`
  final PreferredSizeWidget? appBar; // ✅ Allow custom app bar
  final Widget? floatingActionButton; // ✅ Allow FAB

  const AdaptiveScaffold({
    super.key,
    required this.destinations,
    this.navigationMode = AdaptiveNavigationMode.auto,
    this.title = '',
    this.useAutoRoute = true,
    this.navigatorKey,
    this.body, // ✅ New body parameter
    this.appBar, // ✅ New appBar parameter
    this.floatingActionButton, // ✅ New FAB parameter
  });

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    if (widget.useAutoRoute) {
      AutoRouteHelper.instance
          .pushRoute(context, widget.destinations[index].autoRouteDestination);
    } else {
      setState(() {
        _selectedIndex = index;
      });
      widget.navigatorKey?.currentState?.pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                widget.destinations[index].normalRouteDestination!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useAutoRoute) {
      return AutoRouteHelper.instance.wrapWithAutoTabsRouter(
        routes: widget.destinations
            .map<PageRouteInfo>((item) => item.autoRouteDestination)
            .toList(),
        builder: (context, child, controller) {
          final tabsRouter = AutoTabsRouter.of(context);
          return _buildScaffold(context, child, tabsRouter.activeIndex,
              tabsRouter.setActiveIndex);
        },
      );
    } else {
      return _buildScaffold(
        context,
        widget.body ?? const SizedBox(), // ✅ Use `body` instead of `child`
        _selectedIndex,
        _onDestinationSelected,
      );
    }
  }

  Widget _buildScaffold(BuildContext context, Widget body, int index,
      ValueChanged<int> onSelect) {
    final bool isLargeScreen = Responsive.isDesktop(context);
    final bool useSidebarDrawer =
        widget.navigationMode == AdaptiveNavigationMode.sidebar && isLargeScreen;

    return Scaffold(
      appBar: widget.appBar ?? AppBar(title: Text(widget.title)), // ✅ Use custom app bar
      drawer: useSidebarDrawer
          ? Drawer(
              child: AdaptiveNavigation(
                destinations: widget.destinations,
                selectedIndex: index,
                onDestinationSelected: onSelect,
                mode: widget.navigationMode,
                isSidebarDrawer: true,
              ),
            )
          : null,
      body: Row(
        children: [
          if (!useSidebarDrawer)
            AdaptiveNavigation(
              destinations: widget.destinations,
              selectedIndex: index,
              onDestinationSelected: onSelect,
              mode: widget.navigationMode,
            ),
          Expanded(child: widget.body ?? body), // ✅ Display the passed body
        ],
      ),
      floatingActionButton: widget.floatingActionButton, // ✅ Support FAB
      bottomNavigationBar: Responsive.isMobile(context) ||
              widget.navigationMode == AdaptiveNavigationMode.bottom
          ? AdaptiveNavigation(
              destinations: widget.destinations,
              selectedIndex: index,
              onDestinationSelected: onSelect,
              mode: AdaptiveNavigationMode.bottom,
            )
          : null,
    );
  }
}
