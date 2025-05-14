import 'package:flutter/material.dart';
import 'group_item.dart';

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _StickyHeaderDelegate({
    required this.child,
    required this.height,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}

class GroupedDynamicHeightGridView<G, T> extends StatelessWidget {
  const GroupedDynamicHeightGridView({
    Key? key,
    required this.groupedItems,
    required this.itemBuilder,
    required this.headerBuilder,
    required this.crossAxisCount,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.wrapperBuilder,
    this.headerPadding = const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    this.gridViewPadding = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    this.emptyBuilder,
    this.onRefresh,
    this.isLoading = false,
    this.loadingBuilder,
    this.stickyHeaderIndex = 0, // New parameter to specify which header should be sticky
  }) : super(key: key);

  final List<Group<G, T>> groupedItems;
  final Widget Function(BuildContext, G, T, int) itemBuilder;
  final Widget Function(BuildContext, G) headerBuilder;
  final int Function(G groupKey) crossAxisCount; // ✅ Changed to Function
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool shrinkWrap;
  final Widget Function(BuildContext, Widget, G groupKey)?
      wrapperBuilder; // ✅ Updated to include `groupKey`
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry gridViewPadding;
  final Widget Function(BuildContext, G)? emptyBuilder;
  final Future<void> Function()? onRefresh;
  final bool isLoading;
  final Widget Function(BuildContext, G)? loadingBuilder;
  final int stickyHeaderIndex; // New parameter

  @override
  Widget build(BuildContext context) {
    Widget content = CustomScrollView(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      slivers: _buildSlivers(context),
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: content,
      );
    }

    return content;
  }

  List<Widget> _buildSlivers(BuildContext context) {
    final List<Widget> slivers = [];

    for (int groupIndex = 0; groupIndex < groupedItems.length; groupIndex++) {
      final group = groupedItems[groupIndex];
      
      // Create header
      final header = Padding(
        padding: headerPadding,
        child: headerBuilder(context, group.groupKey),
      );

      // Add header as sticky or regular based on index
      if (groupIndex == stickyHeaderIndex) {
        slivers.add(
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: header,
              height: 56.0, // Adjust this value based on your header height
            ),
          ),
        );
      } else {
        slivers.add(SliverToBoxAdapter(child: header));
      }

      // Add content
      Widget content;
      if (isLoading && loadingBuilder != null) {
        content = Padding(
          padding: gridViewPadding,
          child: loadingBuilder!(context, group.groupKey),
        );
      } else if (group.items.isEmpty && emptyBuilder != null) {
        content = Padding(
          padding: gridViewPadding,
          child: emptyBuilder!(context, group.groupKey),
        );
      } else {
        Widget gridView = _buildGridView(group);
        content = wrapperBuilder != null
            ? wrapperBuilder!(context, gridView, group.groupKey)
            : Padding(
                padding: gridViewPadding,
                child: gridView,
              );
      }

      slivers.add(SliverToBoxAdapter(child: content));
    }

    return slivers;
  }

  /// ✅ Extracted GridView Builder (Avoids Repetition)
  Widget _buildGridView(Group<G, T> group) {
    final itemCount = group.items.length;
    final isSingleColumn = crossAxisCount(group.groupKey) == 1;

    if (isSingleColumn) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, itemIndex) => itemBuilder(
            context, group.groupKey, group.items[itemIndex], itemIndex),
      );
    }

    return DynamicHeightGridView(
      builder: (context, itemIndex) => itemBuilder(
          context, group.groupKey, group.items[itemIndex], itemIndex),
      itemCount: group.items.length,
      crossAxisCount: crossAxisCount(group.groupKey), // ✅ Use dynamic count
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      rowCrossAxisAlignment: rowCrossAxisAlignment,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

/// Sliver Dynamic Height GridView
class SliverDynamicHeightGridView extends StatelessWidget {
  const SliverDynamicHeightGridView({
    Key? key,
    required this.builder,
    required this.itemCount,
    required this.crossAxisCount,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final CrossAxisAlignment rowCrossAxisAlignment;

  int columnLength() {
    return (itemCount / crossAxisCount).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, columnIndex) {
          return _GridRow(
            columnIndex: columnIndex,
            builder: builder,
            itemCount: itemCount,
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisAlignment: rowCrossAxisAlignment,
          );
        },
        childCount: columnLength(),
      ),
    );
  }
}

/// Non-sliver Dynamic Height GridView
class DynamicHeightGridView extends StatelessWidget {
  const DynamicHeightGridView({
    Key? key,
    required this.builder,
    required this.itemCount,
    required this.crossAxisCount,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.shrinkWrap = false,
    this.physics,
  }) : super(key: key);

  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: (itemCount / crossAxisCount).ceil(),
      itemBuilder: (ctx, rowIndex) {
        return _GridRow(
          columnIndex: rowIndex,
          builder: builder,
          itemCount: itemCount,
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisAlignment: rowCrossAxisAlignment,
        );
      },
    );
  }
}

class _GridRow extends StatelessWidget {
  const _GridRow({
    Key? key,
    required this.columnIndex,
    required this.builder,
    required this.itemCount,
    required this.crossAxisCount,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
    required this.crossAxisAlignment,
  }) : super(key: key);

  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final CrossAxisAlignment crossAxisAlignment;
  final int columnIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: (columnIndex == 0) ? 0 : mainAxisSpacing,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: crossAxisCount == 1
                  ? CrossAxisAlignment
                      .start // Align to start when only 1 column
                  : CrossAxisAlignment.stretch,
              children: List.generate(
                (crossAxisCount * 2) - 1,
                (rowIndex) {
                  final rowNum = rowIndex + 1;
                  if (rowNum % 2 == 0) {
                    return SizedBox(width: crossAxisSpacing);
                  }
                  final rowItemIndex = ((rowNum + 1) ~/ 2) - 1;
                  final itemIndex =
                      (columnIndex * crossAxisCount) + rowItemIndex;
                  if (itemIndex > itemCount - 1) {
                    return Expanded(child: SizedBox());
                  }
                  return crossAxisCount == 1
                      ? builder(context,
                          itemIndex) // Directly use the item when only 1 column
                      : Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(child: builder(context, itemIndex)),
                            ],
                          ),
                        );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
