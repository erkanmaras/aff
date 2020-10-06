import 'package:flutter/material.dart';

class IndentDivider extends Divider {
  const IndentDivider({
    Key key,
    double height,
    double thickness,
    double indent = 10,
    double endIndent = 10,
    Color color,
  }) : super(
          key: key,
          height: height,
          thickness: thickness,
          indent: indent,
          endIndent: endIndent,
          color: color,
        );
}
