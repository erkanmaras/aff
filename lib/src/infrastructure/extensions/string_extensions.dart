extension StringExtensions on String {
  String orDefault() => this ?? '';

  bool isNullOrEmpty() => this == null || isEmpty;

  bool isNullOrWhiteSpace() => this == null || isEmpty || trim() == '';

  bool isDigit() => !isNullOrEmpty() || codeUnitAt(0) ^ 0x30 <= 9;

  bool equalsIgnoreCase(String value) =>
      (this == null && value == null) || (this != null && value != null && toLowerCase() == value.toLowerCase());

  bool containsIgnoreCase(String value) => this != null && value != null && toLowerCase().contains(value.toLowerCase());

  int compareIgnoreCase(String value) => toLowerCase().compareTo(value.toLowerCase());

}
