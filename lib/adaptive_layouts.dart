library adaptive_layouts;

export 'src/responsive/responsive_helper.dart';
export 'src/navigation/adaptive_navigation.dart';
export 'src/navigation_mode.dart';
export 'src/scroll_views/adaptive_scroll_view.dart';
export 'src/scroll_views/group_item.dart';
export 'src/navigation/adaptive_scaffold.dart';
export 'src/navigation/navigation_item.dart';

// Conditional import for AutoRouteHelper
export 'src/navigation/auto_route_helper.dart'
    if (dart.library.io) 'src/navigation/auto_route_helper_impl.dart'
    if (dart.library.html) 'src/navigation/auto_route_helper_fallback.dart';
