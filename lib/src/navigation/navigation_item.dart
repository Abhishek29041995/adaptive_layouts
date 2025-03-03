import 'package:flutter/material.dart';

class NavigationItem {
  final String label;
  final Widget icon; // Accepts any Widget (Icon or Image)

  NavigationItem({
    required this.label,
    required this.icon,
  });
}
