import 'package:flutter/material.dart';
import '../navigation/adaptive_navigation.dart';
import '../navigation/navigation_item.dart';
import '../navigation_mode.dart';
import '../responsive/responsive_helper.dart';

class AdaptiveScaffold extends StatelessWidget {
  final List<NavigationItem> destinations;
  final List<Widget> pages;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final AdaptiveNavigationMode navigationMode;
  final String title;

  const AdaptiveScaffold({
    super.key,
    required this.destinations,
    required this.pages,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.navigationMode = AdaptiveNavigationMode.auto,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = Responsive.isDesktop(context);
    final bool useSidebarDrawer =
        navigationMode == AdaptiveNavigationMode.sidebar && isLargeScreen;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: useSidebarDrawer
          ? Drawer(
              child: AdaptiveNavigation(
                destinations: destinations,
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                mode: navigationMode,
                isSidebarDrawer: true,
              ),
            )
          : null,
      body: Row(
        children: [
          if (!useSidebarDrawer) // Only show sidebar if not using as a drawer
            AdaptiveNavigation(
              destinations: destinations,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              mode: navigationMode,
            ),
          Expanded(
            child: pages[selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: Responsive.isMobile(context) ||
              navigationMode == AdaptiveNavigationMode.bottom
          ? AdaptiveNavigation(
              destinations: destinations,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              mode: AdaptiveNavigationMode.bottom,
            )
          : null,
    );
  }
}
