//SOURCE: https://stackoverflow.com/questions/60458885/how-to-autocorrect-scroll-position-in-a-listview-flutter

import 'package:flutter/material.dart';

class SnapScrollSize extends ScrollPhysics {
  final double snapSize;

  const SnapScrollSize({required this.snapSize, super.parent});

  @override
  SnapScrollSize applyTo(ScrollPhysics? ancestor) {
    return SnapScrollSize(snapSize: snapSize, parent: buildParent(ancestor));
  }

  double _getTargetPixels(double velocity, double pixels) {
    double snap = snapSize;
    double target = (pixels / snap).round() * snap;
    return target;
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return offset;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.minScrollExtent)
      return value - position.minScrollExtent;
    if (value > position.maxScrollExtent)
      return value - position.maxScrollExtent;
    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if ((velocity.abs() >= toleranceFor(position).velocity ||
        position.outOfRange)) {
      final target = _getTargetPixels(velocity, position.pixels);
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: toleranceFor(position), // Fixed deprecated tolerance
      );
    }
    return null;
  }
}
