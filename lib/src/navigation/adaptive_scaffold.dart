import 'package:flutter/material.dart';
import '../navigation/navigation_item.dart';
import '../navigation_mode.dart';
import '../responsive/responsive_helper.dart';
import '../navigation/adaptive_navigation.dart';

class AdaptiveScaffold extends StatelessWidget {
  final List<NavigationItem> destinations;
  final AdaptiveNavigationMode navigationMode;
  final String title;
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const AdaptiveScaffold({
    super.key,
    required this.destinations,
    this.navigationMode = AdaptiveNavigationMode.auto,
    this.title = '',
    this.body,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = Responsive.isDesktop(context);
    final bool useSidebarDrawer =
        navigationMode == AdaptiveNavigationMode.sidebar && isLargeScreen;

    return Scaffold(
      appBar: appBar ?? AppBar(title: Text(title)),
      drawer: useSidebarDrawer
          ? Drawer(
              child: AdaptiveNavigation(
                destinations: destinations,
                selectedIndex: 0, // Default selected index
                onDestinationSelected: (index) {}, // Handle selection
                mode: navigationMode,
                isSidebarDrawer: true,
              ),
            )
          : null,
      body: Row(
        children: [
          if (!useSidebarDrawer)
            AdaptiveNavigation(
              destinations: destinations,
              selectedIndex: 0,
              onDestinationSelected: (index) {},
              mode: navigationMode,
            ),
          Expanded(child: body ?? const SizedBox()), // ✅ Default body
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: Responsive.isMobile(context) ||
              navigationMode == AdaptiveNavigationMode.bottom
          ? AdaptiveNavigation(
              destinations: destinations,
              selectedIndex: 0,
              onDestinationSelected: (index) {},
              mode: AdaptiveNavigationMode.bottom,
            )
          : null,
    );
  }
}
