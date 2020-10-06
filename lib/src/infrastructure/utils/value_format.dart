import 'package:intl/intl.dart';

class ValueFormat {
  static String timeToString(DateTime value) {
    return timeFormat().format(value);
  }

  static String dateToString(DateTime value) {
    return dateFormat().format(value);
  }

  static String dateTimeToString(DateTime value) {
    return dateTimeFormat().format(value);
  }

  static String doubleToString(double value, {int decimalPlaces = 2}) {
    return value.toStringAsFixed(decimalPlaces);
  }

  static String qtyToString(double value) {
    // take qty digits from somewhere!
    return NumberFormat('###.##').format(value);
  }

  static String moneyToString(double value) {
    // take money digits from somewhere!
    return NumberFormat('###.00').format(value);
  }

  static DateFormat dateFormat() {
    return DateFormat.yMd();
  }

  static DateFormat timeFormat() {
    return DateFormat.Hm();
  }

  static DateFormat dateTimeFormat() {
    return DateFormat.yMd().add_Hm();
  }
}
