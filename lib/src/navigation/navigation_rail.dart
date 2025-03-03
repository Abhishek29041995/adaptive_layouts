import 'package:flutter/material.dart';
import 'navigation_item.dart';

class AdaptiveNavigationRail extends StatelessWidget {
  final List<NavigationItem> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AdaptiveNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      destinations: destinations
          .map((item) => NavigationRailDestination(
                icon: item.icon,
                label: Text(item.label),
              ))
          .toList(),
    );
  }
}
