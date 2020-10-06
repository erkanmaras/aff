import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ThemeUtils {
  static OutlineInputBorder inputBorder(Color color, BorderRadius borderRadius, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: color,
        width: width,
        style: BorderStyle.solid,
      ),
    );
  }

  static TextTheme textThemeCopyWith(
    TextTheme base,
    Color color,
    String fontFamily,
  ) {
    return TextTheme(
        headline1: base.headline1.copyWith(color: color, fontFamily: fontFamily),
        headline2: base.headline2.copyWith(color: color, fontFamily: fontFamily),
        headline3: base.headline3.copyWith(color: color, fontFamily: fontFamily),
        headline4: base.headline4.copyWith(color: color, fontFamily: fontFamily),
        headline5: base.headline5.copyWith(color: color, fontFamily: fontFamily),
        headline6: base.headline6.copyWith(color: color, fontFamily: fontFamily),
        subtitle1: base.subtitle1.copyWith(color: color, fontFamily: fontFamily),
        subtitle2: base.subtitle2.copyWith(color: color, fontFamily: fontFamily),
        bodyText1: base.bodyText1.copyWith(color: color, fontFamily: fontFamily),
        bodyText2: base.bodyText2.copyWith(color: color, fontFamily: fontFamily),
        caption: base.caption.copyWith(color: color, fontFamily: fontFamily),
        button: base.button.copyWith(color: color, fontFamily: fontFamily),
        overline: base.overline.copyWith(color: color, fontFamily: fontFamily));
  }
}
