import 'package:flutter/material.dart';
import 'group_item.dart';

/// GridView with dynamic height and group support./// GridView with dynamic height and group support.
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
    this.wrapperBuilder, // ✅ Updated to include `groupKey`
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: groupedItems.length,
      itemBuilder: (ctx, groupIndex) {
        final group = groupedItems[groupIndex];

        Widget gridView = _buildGridView(group);

        // ✅ Apply wrapper if provided
        if (wrapperBuilder != null) {
          gridView = wrapperBuilder!(ctx, gridView, group.groupKey);
        } else {
          gridView = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: gridView,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Always Show Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: headerBuilder(ctx, group.groupKey),
            ),
            gridView,
          ],
        );
      },
    );
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
