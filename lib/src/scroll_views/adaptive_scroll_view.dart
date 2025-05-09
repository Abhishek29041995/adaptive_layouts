import 'package:adaptive_layouts/src/scroll_views/group_item.dart';
import 'package:flutter/material.dart';
import '../responsive/responsive_helper.dart';
import 'scroll_list.dart';
import 'scrollable_grid_view.dart';

class AdaptiveScrollView<G, T> extends StatelessWidget {
  final bool isLoading;
  final bool isLoadingMore;
  final List<T> items;
  final List<Group<G, T>> groupedItems;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final Widget Function(BuildContext context, int index, G groupKey)?
      groupHeaderBuilder;
  final String Function(G groupKey)? groupTitleBuilder;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoadingMore;
  final ScrollController controller;
  final Widget header;
  final Widget loadingWidget; // ✅ Optional loading widget
  final Widget loadMoreWidget; // ✅ Optional loading widget
  final Widget noRecordFoundWidget; // ✅ Optional no record widget
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final bool gridViewOnly;

  const AdaptiveScrollView({
    super.key,
    required this.isLoading,
    required this.items,
    required this.itemBuilder,
    required this.controller,
    this.groupedItems = const [],
    this.groupHeaderBuilder,
    this.groupTitleBuilder,
    this.onRefresh,
    this.isLoadingMore = false,
    this.onLoadingMore,
    this.header = const SizedBox.shrink(),
    this.loadingWidget =
        const Center(child: CircularProgressIndicator()), // ✅ Default loading
    this.loadMoreWidget = const SizedBox(
      // Load More Indicator
      height: 50,
      child: Center(child: CircularProgressIndicator()),
    ), // ✅ Default loading
    this.noRecordFoundWidget =
        const Center(child: Text("No records found")), // ✅ Default empty state
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 10.0,
    this.mainAxisSpacing = 10.0,
    this.gridViewOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && items.isEmpty) {
      return loadingWidget; // ✅ Show loading widget
    }

    if (!isLoading && items.isEmpty) {
      return noRecordFoundWidget; // ✅ Show empty state widget
    }
    if (gridViewOnly || !Responsive.isMobile(context)) {
      return ScrollableGridView<G, T>(
        isLoading: isLoading,
        items: items,
        groupedItems: groupedItems,
        itemBuilder: itemBuilder,
        groupHeaderBuilder: groupHeaderBuilder,
        groupTitleBuilder: groupTitleBuilder,
        controller: controller,
        loadingWidget: loadingWidget, // Full screen loader
        loadMoreWidget: loadMoreWidget,
        noRecordFoundWidget: noRecordFoundWidget, // ✅ Pass to GridView
        onRefresh: onRefresh,
        onLoadingMore: onLoadingMore,
        isLoadingMore: isLoadingMore,
        isGrouped: groupedItems.isNotEmpty,
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      );
    } else {
      return ScrollList<G, T>(
        isLoading: isLoading,
        isLoadingMore: isLoadingMore,
        items: items,
        loadingWidget: loadingWidget, // Full screen loader
        loadMoreWidget: loadMoreWidget,
        groupedItems: groupedItems,
        itemBuilder: itemBuilder,
        groupHeaderBuilder: groupHeaderBuilder,
        groupTitleBuilder: groupTitleBuilder,
        controller: controller,
        noRecordFoundWidget: noRecordFoundWidget, // ✅ Pass to ScrollList
        onRefresh: onRefresh,
        onLoadingMore: onLoadingMore,
        header: header,
        isGrouped: groupedItems.isNotEmpty,
      );
    }
  }
}
