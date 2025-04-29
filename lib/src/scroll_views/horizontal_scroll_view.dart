import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'snap_scroll_physic.dart';

class HorizontalListView extends StatefulWidget {
  final ScrollController? controller;
  final int itemCount;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final List<Widget>? children;
  final Widget Function(BuildContext, int)? itemBuilder;
  final CrossAxisAlignment? alignment;
  final double? widthPercentage;

  const HorizontalListView({
    super.key,
    this.controller,
    required this.itemCount,
    required this.crossAxisCount,
    required this.crossAxisSpacing,
    this.children,
    this.itemBuilder,
    this.alignment,
    this.widthPercentage = 100,
  }) : assert(children != null || itemBuilder != null,
            "Either children or itemBuilder must be provided");

  @override
  _HorizontalListViewState createState() => _HorizontalListViewState();
}

class _HorizontalListViewState extends State<HorizontalListView> {
  double _maxItemHeight = 0;
  late List<GlobalKey> itemKeys;

  @override
  void initState() {
    super.initState();
    itemKeys = List.generate(widget.itemCount, (index) => GlobalKey());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate item width based on crossAxisCount and widthPercentage
        double itemWidth;
        if (widget.crossAxisCount == 1) {
          // When crossAxisCount is 1, use the specified percentage of screen width
          itemWidth = constraints.maxWidth * (widget.widthPercentage! / 100);
        } else {
          // When crossAxisCount > 1, divide available space among items
          itemWidth = (constraints.maxWidth -
                  ((widget.crossAxisCount - 1) * widget.crossAxisSpacing)) /
              widget.crossAxisCount;
        }

        // Update snapSize to use itemWidth instead of full screen width
        double snapSize = itemWidth + widget.crossAxisSpacing;
        SnapScrollSize scrollPhysics = SnapScrollSize(snapSize: snapSize);

        // Measure the tallest item's height
        WidgetsBinding.instance.addPostFrameCallback((_) {
          double maxHeight = 0;
          for (var key in itemKeys) {
            final context = key.currentContext;
            if (context != null) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                maxHeight = math.max(maxHeight, box.size.height);
              }
            }
          }
          if (maxHeight > 0 && maxHeight != _maxItemHeight) {
            setState(() {
              _maxItemHeight = maxHeight;
            });
          }
        });

        return SingleChildScrollView(
          controller: widget.controller,
          physics: scrollPhysics,
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: widget.alignment ?? CrossAxisAlignment.end,
            children: List.generate(
              _computeActualChildCount(widget.itemCount),
              (index) {
                if (index.isEven) {
                  return SizedBox(
                    width: itemWidth,
                    height: _maxItemHeight > 0 ? _maxItemHeight : null,
                    child: Container(
                      key: itemKeys[index ~/ 2],
                      child: widget.children != null
                          ? widget.children![index ~/ 2]
                          : widget.itemBuilder!.call(context, index ~/ 2),
                    ),
                  );
                } else {
                  return SizedBox(width: widget.crossAxisSpacing);
                }
              },
            ),
          ),
        );
      },
    );
  }

  int _computeActualChildCount(int itemCount) {
    return math.max(0, (itemCount * 2) - 1);
  }
}
