import 'package:flutter/material.dart';
import 'navigation_item.dart';

class AdaptiveSidebar extends StatelessWidget {
  final List<NavigationItem> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AdaptiveSidebar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: destinations
            .map((item) => ListTile(
                  leading: item.icon,
                  title: Text(item.label),
                  selected: destinations.indexOf(item) == selectedIndex,
                  onTap: () =>
                      onDestinationSelected(destinations.indexOf(item)),
                ))
            .toList(),
      ),
    );
  }
}
