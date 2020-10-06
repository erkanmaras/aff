import 'package:flutter/widgets.dart';
import 'dart:math' as math;

extension SizeExtensions on Size {
   
  /// Percent of the screen height
  /// value = 0..100
  double heightPercent(double value) {
    value = _toPercent(value);
    return value * (height / 100);
  }

  /// Percent of the screen width
  /// value = 0 .. 100
  double widthPercent(double value) {
    value = _toPercent(value);
    return value * (width / 100);
  }

  /// Screen longest side percent.
  /// value = 0 .. 100
  double longestSidePercent(double value) {
    value = _toPercent(value);
    return value * (longestSide / 100);
  }

  /// Screen shortest side percent.
  /// value = 0 .. 100
  double shortestSidePercent(double value) {
    value = _toPercent(value);
    return value * (shortestSide / 100);
  }

  static double _toPercent(double value) {
    return math.min(math.max(value, 0), 100);
  }
}
