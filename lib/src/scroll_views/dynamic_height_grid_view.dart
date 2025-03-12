import 'package:flutter/material.dart';

/// GridView with dynamic height
///
/// Usage is almost same as [GridView.count]

/// GridView with dynamic height
/// Ensures all items in a row have equal height.
class DynamicHeightGridView extends StatelessWidget {
  const DynamicHeightGridView({
    Key? key,
    required this.builder,
    required this.itemCount,
    required this.crossAxisCount,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.controller,
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
  final ScrollController? controller;
  final bool shrinkWrap;

  int columnLength() {
    return (itemCount / crossAxisCount).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: columnLength(),
      itemBuilder: (ctx, columnIndex) {
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
    );
  }
}

/// Use this for [CustomScrollView]
class SliverDynamicHeightGridView extends StatelessWidget {
  const SliverDynamicHeightGridView({
    Key? key,
    required this.builder,
    required this.itemCount,
    required this.crossAxisCount,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.controller,
  }) : super(key: key);

  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final ScrollController? controller;

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
        // Ensures height adapts dynamically
        builder: (context, constraints) {
          return IntrinsicHeight(
            // Forces children to take the height of the tallest one
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    return Expanded(
                        child: SizedBox()); // Keeps alignment in last row
                  }
                  return Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .max, // Forces items to fill available height
                      children: [
                        Expanded(
                            child: builder(
                                context, itemIndex)), // Ensures equal height
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
