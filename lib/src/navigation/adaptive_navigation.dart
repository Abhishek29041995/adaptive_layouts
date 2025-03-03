import 'package:adaptive_layouts/src/navigation/navigation_item.dart';
import 'package:flutter/material.dart';
import '../navigation_mode.dart';
import '../responsive/responsive_helper.dart';
import 'bottom_navigation.dart';
import 'navigation_rail.dart';
import 'sidebar.dart';

class AdaptiveNavigation extends StatelessWidget {
  final List<NavigationItem> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final AdaptiveNavigationMode mode;

  const AdaptiveNavigation({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.mode = AdaptiveNavigationMode.auto,
  });

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case AdaptiveNavigationMode.bottom:
        return AdaptiveBottomNavigation(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
        );

      case AdaptiveNavigationMode.rail:
        return AdaptiveNavigationRail(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
        );

      case AdaptiveNavigationMode.sidebar:
        return AdaptiveSidebar(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
        );

      case AdaptiveNavigationMode.both:
        return Row(
          children: [
            AdaptiveSidebar(
              destinations: destinations,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
            ),
            Expanded(
              child: AdaptiveBottomNavigation(
                destinations: destinations,
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
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
            onDestinationSelected: onDestinationSelected,
          );
        } else if (Responsive.isTablet(context)) {
          return AdaptiveNavigationRail(
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
          );
        } else {
          return AdaptiveSidebar(
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
          );
        }
    }
  }
}
