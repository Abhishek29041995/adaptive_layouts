import 'package:flutter/material.dart';
import '../navigation/navigation_item.dart';
import '../navigation_mode.dart';
import '../responsive/responsive_helper.dart';
import '../navigation/bottom_navigation.dart';
import '../navigation/navigation_rail.dart';
import '../navigation/sidebar.dart';

class AdaptiveNavigation extends StatelessWidget {
  final List<NavigationItem> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final AdaptiveNavigationMode mode;
  final bool isSidebarDrawer;

  const AdaptiveNavigation({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.mode = AdaptiveNavigationMode.auto,
    this.isSidebarDrawer = false,
  });

  void _onItemTapped(BuildContext context, NavigationItem item) {
    if (item.onTap != null) {
      item.onTap!();
    } else if (item.normalRouteDestination != null) {
      // ✅ Normal Navigator.push Navigation
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => item.normalRouteDestination!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case AdaptiveNavigationMode.bottom:
        return AdaptiveBottomNavigation(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) =>
              _onItemTapped(context, destinations[index]),
        );

      case AdaptiveNavigationMode.rail:
        return AdaptiveNavigationRail(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) =>
              _onItemTapped(context, destinations[index]),
        );

      case AdaptiveNavigationMode.sidebar:
        return isSidebarDrawer
            ? const SizedBox()
            : AdaptiveSidebar(
                destinations: destinations,
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) =>
                    _onItemTapped(context, destinations[index]),
              );

      case AdaptiveNavigationMode.both:
        return Row(
          children: [
            AdaptiveSidebar(
              destinations: destinations,
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) =>
                  _onItemTapped(context, destinations[index]),
            ),
            Expanded(
              child: AdaptiveBottomNavigation(
                destinations: destinations,
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) =>
                    _onItemTapped(context, destinations[index]),
              ),
            ),
          ],
        );

      case AdaptiveNavigationMode.auto:
      default:
        if (Responsive.isMobile(context)) {
          return AdaptiveBottomNavigation(
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) =>
                _onItemTapped(context, destinations[index]),
          );
        } else if (Responsive.isTablet(context)) {
          return AdaptiveNavigationRail(
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) =>
                _onItemTapped(context, destinations[index]),
          );
        } else {
          return isSidebarDrawer
              ? const SizedBox()
              : AdaptiveSidebar(
                  destinations: destinations,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) =>
                      _onItemTapped(context, destinations[index]),
                );
        }
    }
  }
}
