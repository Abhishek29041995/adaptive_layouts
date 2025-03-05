import 'package:flutter/material.dart';
import '../navigation/navigation_item.dart';
import '../navigation_mode.dart';
import '../responsive/responsive_helper.dart';
import '../navigation/adaptive_navigation.dart';

class AdaptiveScaffold extends StatefulWidget {
  final List<NavigationItem> destinations;
  final AdaptiveNavigationMode navigationMode;
  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  const AdaptiveScaffold({
    super.key,
    required this.destinations,
    this.navigationMode = AdaptiveNavigationMode.auto,
    this.title = '',
    required this.body,
    this.floatingActionButton,
  });

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = Responsive.isDesktop(context);
    final bool isTablet = Responsive.isTablet(context);
    final bool useSidebar = widget.navigationMode == AdaptiveNavigationMode.sidebar && isLargeScreen;
    final bool useBothNavigation = widget.navigationMode == AdaptiveNavigationMode.both && isTablet;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      drawer: useSidebar
          ? Drawer(
              child: AdaptiveNavigation(
                destinations: widget.destinations,
                selectedIndex: _selectedIndex,
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
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              mode: AdaptiveNavigationMode.sidebar,
            ),
          Expanded(child: widget.body),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: (Responsive.isMobile(context) ||
              widget.navigationMode == AdaptiveNavigationMode.bottom ||
              useBothNavigation)
          ? AdaptiveNavigation(
              destinations: widget.destinations,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              mode: AdaptiveNavigationMode.bottom,
            )
          : null,
    );
  }
}
