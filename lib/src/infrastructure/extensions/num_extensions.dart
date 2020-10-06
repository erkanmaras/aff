extension IntExtensions on int {
  int orDefault() => this ?? 0;
}

extension DoubleExtensions on double {
  double orDefault() => this ?? 0;
}

extension NumExtensions on num {
  double orDefault() => this is int ? 0 : 0.0;
}
