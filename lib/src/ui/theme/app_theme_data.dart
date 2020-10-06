import 'package:flutter/material.dart';
import 'iapp_text_styles.dart';
import 'iapp_colors.dart';

class AppThemeData {
  AppThemeData(this.data, this.color, this.textStyles);

  ThemeData data;
  IAppColors color;
  IAppTextStyles textStyles;
}