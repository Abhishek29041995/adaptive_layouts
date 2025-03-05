import 'package:flutter/material.dart';
import '../navigation/navigation_item.dart';
import '../navigation_mode.dart';
import '../responsive/responsive_helper.dart';
import '../navigation/adaptive_navigation.dart';

class AdaptiveScaffold extends StatefulWidget {
  final List<NavigationItem> destinations;
  final AdaptiveNavigationMode navigationMode;
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final int? externalIndex; // For external tab control (AutoTabsRouter)
  final void Function(int)? onTabChange; // Callback for tab changes

  const AdaptiveScaffold({
    super.key,
    this.appBar,
    required this.destinations,
    this.navigationMode = AdaptiveNavigationMode.auto,
    required this.child,
    this.floatingActionButton,
    this.externalIndex,
    this.onTabChange,
  });

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.externalIndex ?? 0; // Use external index if provided
  }

  void _onDestinationSelected(int index) {
    if (widget.onTabChange != null) {
      widget.onTabChange!(index); // Notify parent (for AutoTabsRouter)
    } else {
      setState(() {
        _selectedIndex = index; // Normal tab change
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = Responsive.isDesktop(context);
    final bool isTablet = Responsive.isTablet(context);
    final bool useSidebar = widget.navigationMode == AdaptiveNavigationMode.sidebar && isLargeScreen;
    final bool useBothNavigation = widget.navigationMode == AdaptiveNavigationMode.both && isTablet;

    return Scaffold(
      appBar: widget.appBar,
      drawer: useSidebar
          ? Drawer(
              child: AdaptiveNavigation(
                destinations: widget.destinations,
                selectedIndex: widget.externalIndex ?? _selectedIndex,
                onDestinationSelected: _onDestinationSelected,
                mode: widget.navigationMode,
                isSidebarDrawer: true,
              ),
            )
          : null,
      body: Row(
        children: [
          if (widget.navigationMode == AdaptiveNavigationMode.sidebar || useBothNavigation)
            AdaptiveNavigation(
              destinations: widget.destinations,
              selectedIndex: widget.externalIndex ?? _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              mode: AdaptiveNavigationMode.sidebar,
            ),
          Expanded(child: widget.child),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: (Responsive.isMobile(context) ||
              widget.navigationMode == AdaptiveNavigationMode.bottom ||
              useBothNavigation)
          ? AdaptiveNavigation(
              destinations: widget.destinations,
              selectedIndex: widget.externalIndex ?? _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              mode: AdaptiveNavigationMode.bottom,
            )
          : null,
    );
  }
}
