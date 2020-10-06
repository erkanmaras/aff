 
import '../utils/type.dart';

extension MapExtensions on Map<String, dynamic> {
  bool isNullOrEmpty() => this == null || isEmpty;

  T getValue<T>(String key, {T defaultValue}) {
    dynamic value = this[key];

    if (T == String) {
      if (value == null) {
        return defaultValue ?? DefaultValues.stringValue as T;
      }

      if (value is! String) {
        return value.toString() as T;
      }
    } else if (T == int) {
      if (value == null) {
        return defaultValue ?? DefaultValues.intValue as T;
      }

      if (value is double) {
        return value.toInt() as T;
      }
    } else if (T == double) {
      if (value == null) {
        return defaultValue ?? DefaultValues.doubleValue as T;
      }

      if (value is int) {
        return value.toDouble() as T;
      }
    } else if (T == bool) {
      if (value == null) {
        return defaultValue ?? DefaultValues.boolValue as T;
      }

      if (value is String) {
        return (value.toLowerCase() == 'true' || value.toLowerCase() == '1') as T;
      }
    } else if (T == DateTime) {
      if (value == null) {
        return defaultValue ?? DefaultValues.dateTimeValue as T;
      }
      if (value is String) {
        {
          return DateTime.tryParse(value) as T;
        }
      }
    }
    return value as T;
  }
}
