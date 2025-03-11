import 'package:adaptive_layouts/src/scroll_views/group_item.dart';
import 'package:flutter/material.dart';

class ScrollableGridView<G, T> extends StatefulWidget {
  final VoidCallback? onRefresh;
  final VoidCallback? onLoadingMore;
  final bool isLoading;
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

  const ScrollableGridView({
    super.key,
    required this.isLoading,
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
          widget.items.isNotEmpty) {
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
    final itemCount = widget.items.length;

    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: constraints.maxWidth / widget.crossAxisCount,
            crossAxisSpacing: widget.crossAxisSpacing,
            mainAxisSpacing: widget.mainAxisSpacing,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = widget.items[index];
              return widget.itemBuilder(context, index, item);
            },
            childCount: itemCount,
          ),
        ),
      ),
    ];
  }

  /// ✅ **Grouped Grid View**
  List<Widget> _buildGroupedGrid(BoxConstraints constraints) {
    final slivers = <Widget>[];

    for (var i = 0; i < widget.groupedItems.length; i++) {
      final group = widget.groupedItems[i];

      // Get group title using function or fallback to `.toString()`
      final groupTitle = widget.groupTitleBuilder?.call(group.groupKey) ??
          group.groupKey.toString();

      // ✅ Group Header
      slivers.add(
        SliverToBoxAdapter(
          child: widget.groupHeaderBuilder?.call(context, i, group.groupKey) ??
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  groupTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        ),
      );

      // ✅ Grouped Grid Items
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: constraints.maxWidth / widget.crossAxisCount,
              crossAxisSpacing: widget.crossAxisSpacing,
              mainAxisSpacing: widget.mainAxisSpacing,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = group.items[index];
                return widget.itemBuilder(context, index, item);
              },
              childCount: group.items.length,
            ),
          ),
        ),
      );
    }

    return slivers;
  }
}