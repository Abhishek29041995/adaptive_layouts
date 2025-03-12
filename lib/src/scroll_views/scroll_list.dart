import 'package:adaptive_layouts/src/scroll_views/group_item.dart';
import 'package:flutter/material.dart';

class ScrollList<G, T> extends StatefulWidget {
  final VoidCallback? onRefresh;
  final VoidCallback? onLoadingMore;
  final bool isLoading;
  final bool isLoadingMore;
  final List<T> items;
  final List<Group<G, T>> groupedItems;
  final Widget loadingWidget;
  final Widget loadMoreWidget;
  final Widget noRecordFoundWidget;
  final Widget header;
  final ScrollController controller;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final Widget Function(BuildContext context, int index, G groupKey)?
      groupHeaderBuilder;
  final String Function(G groupKey)? groupTitleBuilder;
  final bool dismissOnDrag;
  final bool isGrouped;

  const ScrollList({
    super.key,
    required this.isLoading,
    required this.isLoadingMore,
    required this.itemBuilder,
    required this.items,
    required this.loadingWidget,
    required this.loadMoreWidget,
    required this.noRecordFoundWidget,
    required this.controller,
    this.groupedItems = const [],
    this.groupHeaderBuilder,
    this.groupTitleBuilder,
    this.header = const SizedBox.shrink(),
    this.onRefresh,
    this.onLoadingMore,
    this.dismissOnDrag = false,
    this.isGrouped = false,
  });

  @override
  State<ScrollList<G, T>> createState() => _ScrollListState<G, T>();
}

class _ScrollListState<G, T> extends State<ScrollList<G, T>> {
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
        ? widget.loadingWidget // Full screen loader (Initial Loading)
        : RefreshIndicator(
            onRefresh: () async => widget.onRefresh?.call(),
            child: CustomScrollView(
              controller: _controller,
              keyboardDismissBehavior: widget.dismissOnDrag
                  ? ScrollViewKeyboardDismissBehavior.onDrag
                  : ScrollViewKeyboardDismissBehavior.manual,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: widget.header),

                if (widget.isGrouped) ..._buildGroupedList(),

                if (!widget.isGrouped)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = widget.items[index];
                        return widget.itemBuilder(context, index, item);
                      },
                      childCount: widget.items.length,
                    ),
                  ),

                // Load More Indicator (Appears only during pagination)
                if (widget.isLoadingMore && widget.items.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: widget.loadMoreWidget),
                    ),
                  ),

                // No Records Found Widget
                if (widget.items.isEmpty && !widget.isLoading)
                  SliverToBoxAdapter(child: widget.noRecordFoundWidget),
              ],
            ),
          );
  }

  List<Widget> _buildGroupedList() {
    final slivers = <Widget>[];

    for (var i = 0; i < widget.groupedItems.length; i++) {
      final group = widget.groupedItems[i];

      // Get title from groupKey using `groupTitleBuilder`
      final groupTitle = widget.groupTitleBuilder?.call(group.groupKey) ??
          group.groupKey.toString();

      slivers.add(
        SliverToBoxAdapter(
          child: widget.groupHeaderBuilder?.call(context, i, group.groupKey) ??
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  groupTitle,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
        ),
      );

      slivers.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = group.items[index];
              return widget.itemBuilder(context, index, item);
            },
            childCount: group.items.length,
          ),
        ),
      );
    }

    return slivers;
  }
}
