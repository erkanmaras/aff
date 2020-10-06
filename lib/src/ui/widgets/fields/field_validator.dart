import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:aff/infrastructure.dart';

abstract class FieldValidator<T> {
  FieldValidator(this.errorText) : assert(errorText != null);

  /// the errorText to display when the validation fails
  final String errorText;

  /// checks the input against the given conditions
  bool isValid(T value);

  String call(T value) {
    return isValid(value) ? null : errorText;
  }
}

abstract class TextFieldValidator extends FieldValidator<String> {
  TextFieldValidator(String errorText) : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.
  bool get ignoreEmptyValues => true;

  @override
  String call(String value) {
    return (ignoreEmptyValues && value.isNullOrEmpty())
        ? null
        : super.call(value);
  }

  /// helper function to check if an input matches a given pattern
  bool hasMatch(String pattern, String input) =>
      RegExp(pattern).hasMatch(input);
}

class MaxLengthValidator extends TextFieldValidator {
  MaxLengthValidator({@required this.max, @required String errorText})
      : super(errorText);

  final int max;

  @override
  bool isValid(String value) {
    return value.length <= max;
  }
}

class MinLengthValidator extends TextFieldValidator {
  MinLengthValidator({@required this.min, @required String errorText})
      : super(errorText);

  final int min;

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String value) {
    return value.length >= min;
  }
}

class LengthRangeValidator extends TextFieldValidator {
  LengthRangeValidator(
      {@required this.min, @required this.max, @required String errorText})
      : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  final int min;
  final int max;

  @override
  bool isValid(String value) {
    return value.length >= min && value.length <= max;
  }
}

class RangeValidator extends TextFieldValidator {
  RangeValidator(
      {@required this.min, @required this.max, @required String errorText})
      : super(errorText);

  final num min;
  final num max;

  @override
  bool isValid(String value) {
    try {
      final numericValue = num.parse(value);
      return numericValue >= min && numericValue <= max;
    } catch (_) {
      return false;
    }
  }
}

class EmailValidator extends TextFieldValidator {
  EmailValidator({@required String errorText}) : super(errorText);

  final String _emailPattern =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";

  @override
  bool isValid(String value) => hasMatch(_emailPattern, value);
}

class PatternValidator extends TextFieldValidator {
  PatternValidator({@required this.pattern, @required String errorText})
      : super(errorText);

  final String pattern;

  @override
  bool isValid(String value) => hasMatch(pattern, value);
}

class DateTextValidator extends TextFieldValidator {
  DateTextValidator({@required this.format, @required String errorText})
      : super(errorText);

  final String format;

  @override
  bool isValid(String value) {
    try {
      final dateTime = DateFormat(format).parseStrict(value);
      return dateTime != null;
    } catch (_) {
      return false;
    }
  }
}

class RequiredValidator<T> extends FieldValidator<T> {
  RequiredValidator({@required String errorText}) : super(errorText);

  @override
  bool isValid(T value) {
    if (value is String) {
      return !value.isNullOrEmpty();
    } else if (value is int) {
      return value != null && value != DefaultValues.intValue;
    } else if (value is double) {
      return value != null && value != DefaultValues.doubleValue;
    } else if (value is DateTime) {
      return !value.isNullOrEmpty();
    }
    return value != null;
  }
}

class MatchValidator extends TextFieldValidator {
  MatchValidator({@required this.matchValue, @required String errorText})
      : super(errorText);

  final String matchValue;

  String validateMatch(String value, String value2) {
    return value == value2 ? null : errorText;
  }

  @override
  bool isValid(String value) {
    return (matchValue ?? '' == value ?? '') as bool;
  }
}

class MultiValidator extends FieldValidator<dynamic> {
  MultiValidator({@required this.validators}) : super(_errorText);

  final List<FieldValidator> validators;
  static String _errorText = '';

  @override
  bool isValid(dynamic value) {
    for (FieldValidator validator in validators) {
      if (!validator.isValid(value)) {
        _errorText = validator.errorText;
        return false;
      }
    }
    return true;
  }

  @override
  String call(dynamic value) {
    return isValid(value) ? null : _errorText;
  }
}
