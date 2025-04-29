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
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    itemKeys = List.generate(widget.itemCount, (index) => GlobalKey());
    _scrollController = widget.controller ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth;
        if (widget.crossAxisCount == 1) {
          itemWidth = constraints.maxWidth * (widget.widthPercentage! / 100);
        } else {
          itemWidth = (constraints.maxWidth -
                  ((widget.crossAxisCount - 1) * widget.crossAxisSpacing)) /
              widget.crossAxisCount;
        }

        double snapSize = itemWidth + widget.crossAxisSpacing;

        return SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics().applyTo(
            SnapScrollSize(
              snapSize: snapSize,
              maxScrollVelocity:
                  3500, // Increased velocity for smoother scrolling
              minScrollVelocity: 150, // Minimum velocity for snap
              springDescription: const SpringDescription(
                mass: 0.5, // Reduced mass for faster response
                stiffness: 200, // Increased stiffness for better snap
                damping: 1.1, // Adjusted damping for smooth stop
              ),
            ),
          ),
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
