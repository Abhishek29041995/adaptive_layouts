import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'adaptive_navigation.dart';
import '../navigation/navigation_item.dart';
import '../navigation_mode.dart';
import '../responsive/responsive_helper.dart';

class AdaptiveScaffold extends StatefulWidget {
  final List<NavigationItem> destinations;
  final AdaptiveNavigationMode navigationMode;
  final String title;
  final bool useAutoRoute;
  final GlobalKey<NavigatorState>? navigatorKey;

  const AdaptiveScaffold({
    super.key,
    required this.destinations,
    this.navigationMode = AdaptiveNavigationMode.auto,
    this.title = '',
    this.useAutoRoute = true,
    this.navigatorKey,
  });

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    if (widget.useAutoRoute) {
      AutoTabsRouter.of(context).setActiveIndex(index);
    } else {
      setState(() {
        _selectedIndex = index;
      });
      if (widget.navigatorKey?.currentState != null) {
        widget.navigatorKey!.currentState!.pushReplacementNamed(
          widget.destinations[index].routePath,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useAutoRoute) {
      return AutoTabsRouter(
        routes: widget.destinations.map((item) => item.route).toList(),
        builder: (context, child, controller) {
          final tabsRouter = AutoTabsRouter.of(context);
          return _buildScaffold(context, child, tabsRouter.activeIndex, tabsRouter.setActiveIndex);
        },
      );
    } else {
      return _buildScaffold(
        context,
        Navigator(
          key: widget.navigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) {
                final route = widget.destinations.firstWhere(
                  (item) => item.routePath == settings.name,
                  orElse: () => widget.destinations.first,
                );
                return route.screen;
              },
              settings: settings,
            );
          },
        ),
        _selectedIndex,
        _onDestinationSelected,
      );
    }
  }

  Widget _buildScaffold(BuildContext context, Widget child, int index, ValueChanged<int> onSelect) {
    final bool isLargeScreen = Responsive.isDesktop(context);
    final bool useSidebarDrawer =
        widget.navigationMode == AdaptiveNavigationMode.sidebar && isLargeScreen;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
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
          Expanded(child: child),
        ],
      ),
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
