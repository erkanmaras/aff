import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension ThemeDataExtensions on ThemeData {
  BorderRadius cardBorderRadius() {
    return _borderRadius(cardTheme.shape);
  }

  BorderRadius buttonBorderRadius() {
    return _borderRadius(elevatedButtonTheme.style.shape.resolve(null));
  }

  BorderRadius inputBorderRadius() {
    if (inputDecorationTheme.border is OutlineInputBorder) {
      OutlineInputBorder border = inputDecorationTheme.border as OutlineInputBorder;
      return border.borderRadius;
    } else {
      return BorderRadius.circular(0);
    }
  }

  BorderRadius _borderRadius(ShapeBorder shape) {
    if (shape is RoundedRectangleBorder) {
      return shape.borderRadius as BorderRadius;
    } else {
      return BorderRadius.circular(0);
    }
  }
}
