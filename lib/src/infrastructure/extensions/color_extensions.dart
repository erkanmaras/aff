import 'dart:ui';

extension ColorExtensions on Color {
  /// Returns a darken color
  /// value ranges must be in 0.0 to 1.0).
  ///
  /// Out of range values will have unexpected effects.
  Color darken(double value) {
    assert(0 <= value && value <= 1);
    var f = 1 - value;
    return Color.fromARGB(alpha, (red * f).round(), (green * f).round(), (blue * f).round()).withOpacity(opacity);
  }

  /// Returns a lighten color
  /// value ranges must be in 0.0 to 1.0).
  ///
  /// Out of range values will have unexpected effects.
  Color lighten(double value) {
    assert(0 <= value && value <= 1);
    return Color.fromARGB(alpha, red + ((255 - red) * value).round(), green + ((255 - green) * value).round(),
        blue + ((255 - blue) * value).round());
  }
}
