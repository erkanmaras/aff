import 'package:flutter/widgets.dart';

extension MediaQueryDataExtensions on MediaQueryData {
  /// If orientation == portrait than return first value, else return second value
  T ifPortrait<T>(T portraitValue, T landscapeValue) {
    return orientation == Orientation.portrait ? portraitValue : landscapeValue;
  }

  bool keyboardVisible() {
    //Todo(erkan) : Find Better way!
    return viewInsets.bottom > 200;
  }
}
