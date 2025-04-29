import 'package:flutter/material.dart';

class SnapScrollSize extends ScrollPhysics {
  final double snapSize;
  final double maxScrollVelocity;
  final double minScrollVelocity;
  final SpringDescription springDescription;

  const SnapScrollSize({
    super.parent,
    required this.snapSize,
    this.maxScrollVelocity = 3500.0,
    this.minScrollVelocity = 150.0,
    this.springDescription = const SpringDescription(
      mass: 0.5,
      stiffness: 200.0,
      damping: 1.1,
    ),
  });

  @override
  SnapScrollSize applyTo(ScrollPhysics? ancestor) {
    return SnapScrollSize(
      parent: buildParent(ancestor),
      snapSize: snapSize,
      maxScrollVelocity: maxScrollVelocity,
      minScrollVelocity: minScrollVelocity,
      springDescription: springDescription,
    );
  }

  double _getTargetPixels(
      ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = position.pixels / snapSize;

    if (velocity.abs() < minScrollVelocity) {
      return page.round() * snapSize;
    }

    if (velocity > 0.0 && velocity < maxScrollVelocity) {
      return page.ceil() * snapSize;
    }

    if (velocity < 0.0 && velocity > -maxScrollVelocity) {
      return page.floor() * snapSize;
    }

    return position.pixels;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final double target = _getTargetPixels(position, tolerance, velocity);

    if (target != position.pixels) {
      return ScrollSpringSimulation(
        springDescription,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }

    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
