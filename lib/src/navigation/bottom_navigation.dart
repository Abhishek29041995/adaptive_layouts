import 'package:flutter/material.dart';
import '../navigation/navigation_item.dart';

class AdaptiveBottomNavigation extends StatelessWidget {
  final List<NavigationItem> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AdaptiveBottomNavigation({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onDestinationSelected,
      items: destinations
          .map((item) => BottomNavigationBarItem(
                icon: item.icon,
                label: item.label,
              ))
          .toList(),
    );
  }
}
