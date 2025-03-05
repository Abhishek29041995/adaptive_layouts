import 'package:flutter/material.dart';
import '../navigation/navigation_item.dart';
import '../navigation_mode.dart';
import '../responsive/responsive_helper.dart';
import '../navigation/adaptive_navigation.dart';

class AdaptiveScaffold extends StatefulWidget {
  final List<NavigationItem> destinations;
  final AdaptiveNavigationMode navigationMode;
  final List<Widget> pages;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const AdaptiveScaffold({
    super.key,
    this.appBar,
    required this.destinations,
    this.navigationMode = AdaptiveNavigationMode.auto,
    required this.pages,
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
    final bool useSidebar =
        widget.navigationMode == AdaptiveNavigationMode.sidebar && isLargeScreen;
    final bool useBothNavigation =
        widget.navigationMode == AdaptiveNavigationMode.both && isTablet;

    return Scaffold(
      appBar: widget.appBar,
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
          Expanded(child: widget.pages[_selectedIndex]), // Dynamic content switching
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Ensure correct positioning
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
