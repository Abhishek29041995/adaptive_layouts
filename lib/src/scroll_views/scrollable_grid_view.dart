import 'package:flutter/material.dart';
import 'group_item.dart';
import 'dynamic_height_grid_view.dart';

class ScrollableGridView<G, T> extends StatefulWidget {
  final VoidCallback? onRefresh;
  final VoidCallback? onLoadingMore;
  final bool isLoading;
  final bool isLoadingMore;
  final List<T> items;
  final List<Group<G, T>> groupedItems;
  final Widget loadingWidget;
  final Widget noRecordFoundWidget;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final Widget Function(BuildContext context, int index, G groupKey)?
      groupHeaderBuilder;
  final String Function(G groupKey)? groupTitleBuilder;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final ScrollController controller;
  final bool isGrouped;
  final bool isHeaderSticky;

  const ScrollableGridView({
    super.key,
    required this.isLoading,
    required this.isLoadingMore,
    required this.itemBuilder,
    required this.items,
    required this.loadingWidget,
    required this.noRecordFoundWidget,
    required this.controller,
    this.groupedItems = const [],
    this.groupHeaderBuilder,
    this.groupTitleBuilder,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 10.0,
    this.mainAxisSpacing = 10.0,
    this.onRefresh,
    this.onLoadingMore,
    this.isGrouped = false,
    this.isHeaderSticky = false,
  });

  @override
  State<ScrollableGridView<G, T>> createState() =>
      _ScrollableGridViewState<G, T>();
}

class _ScrollableGridViewState<G, T> extends State<ScrollableGridView<G, T>> {
  late ScrollController _controller;

  @override
  void initState() {
    _controller = widget.controller;
    _controller.addListener(() {
      if (_controller.position.pixels >= _controller.position.maxScrollExtent &&
          widget.items.isNotEmpty &&
          !widget.isLoadingMore) {
        widget.onLoadingMore?.call();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading && widget.items.isEmpty
        ? widget.loadingWidget
        : LayoutBuilder(builder: (context, constraints) {
            return RefreshIndicator(
              onRefresh: () async => widget.onRefresh?.call(),
              child: CustomScrollView(
                controller: _controller,
                slivers: widget.isGrouped
                    ? _buildGroupedGrid(constraints)
                    : _buildNormalGrid(constraints),
              ),
            );
          });
  }

  /// ✅ **Normal Grid View (Non-Grouped Data)**
  List<Widget> _buildNormalGrid(BoxConstraints constraints) {
    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        sliver: SliverDynamicHeightGridView(
          crossAxisCount: widget.crossAxisCount,
          itemCount: widget.items.length,
          crossAxisSpacing: widget.crossAxisSpacing,
          mainAxisSpacing: widget.mainAxisSpacing,
          builder: (context, index) {
            return widget.itemBuilder(context, index, widget.items[index]);
          },
        ),
      ),
      _buildLoadMoreIndicator(),
    ];
  }

  /// ✅ **Grouped Grid View with Sticky Headers**
  List<Widget> _buildGroupedGrid(BoxConstraints constraints) {
    final slivers = <Widget>[];

    for (var i = 0; i < widget.groupedItems.length; i++) {
      final group = widget.groupedItems[i];
      final groupTitle = widget.groupTitleBuilder?.call(group.groupKey) ??
          group.groupKey.toString();

      if (widget.isHeaderSticky) {
        slivers.add(
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _StickyHeaderDelegate(
              child: widget.groupHeaderBuilder?.call(context, i, group.groupKey) ??
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                    child: Text(
                      groupTitle,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
            ),
          ),
        );
      } else {
        slivers.add(
          SliverToBoxAdapter(
            child: widget.groupHeaderBuilder?.call(context, i, group.groupKey) ??
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Text(
                    groupTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
          ),
        );
      }

      // ✅ **Use Dynamic Height Grid for Grouped Items**
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          sliver: SliverDynamicHeightGridView(
            crossAxisCount: widget.crossAxisCount,
            itemCount: group.items.length,
            crossAxisSpacing: widget.crossAxisSpacing,
            mainAxisSpacing: widget.mainAxisSpacing,
            builder: (context, index) {
              return widget.itemBuilder(context, index, group.items[index]);
            },
          ),
        ),
      );
    }

    slivers.add(_buildLoadMoreIndicator());

    return slivers;
  }

  /// ✅ **Load More Indicator**
  Widget _buildLoadMoreIndicator() {
    return SliverToBoxAdapter(
      child: widget.isLoadingMore
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            )
          : const SizedBox.shrink(),
    );
  }
}

/// 🔹 **Sticky Header Delegate**
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: overlapsContent ? 2.0 : 0.0,
      child: child,
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
