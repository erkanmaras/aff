import 'package:aff/infrastructure.dart';
import 'package:aff/src/ui/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('RequiredValidator', () {
    final String errorText = 'invalid input message';

    group('String', () {
      final requiredValidator = RequiredValidator<String>(errorText: errorText);
      test('Validate with a null value will return $errorText', () {
        expect(errorText, requiredValidator(null));
      });
      test('Validate with an empty value will return $errorText', () {
        expect(errorText, requiredValidator(DefaultValues.stringValue));
      });
      test('Validate with a value will return null', () {
        expect(null, requiredValidator('valid input'));
      });
    });

    group('Integer', () {
      final requiredValidator = RequiredValidator<int>(errorText: errorText);
      test('Validate with a null value will return $errorText', () {
        expect(errorText, requiredValidator(null));
      });
      test('Validate with an empty value will return $errorText', () {
        expect(errorText, requiredValidator(DefaultValues.intValue));
      });
      test('Validate with a value will return null', () {
        expect(null, requiredValidator(1));
      });
    });

    group('Double', () {
      final requiredValidator = RequiredValidator<double>(errorText: errorText);
      test('validate with a null value will return $errorText', () {
        expect(errorText, requiredValidator(null));
      });
      test('validate with an empty value will return $errorText', () {
        expect(errorText, requiredValidator(DefaultValues.doubleValue));
      });
      test('Validate with a value will return null', () {
        expect(null, requiredValidator(1));
      });
    });

    group('DateTime', () {
      final requiredValidator = RequiredValidator<DateTime>(errorText: errorText);
      test('validate with a null value will return $errorText', () {
        expect(errorText, requiredValidator(null));
      });
      test('validate with an empty value will return $errorText', () {
        final requiredValidator = RequiredValidator<DateTime>(errorText: errorText);
        expect(errorText, requiredValidator(DefaultValues.dateTimeValue));
      });
      test('Validate with a value will return null', () {
        expect(null, requiredValidator(DateTime.now()));
      });
    });
  });

  group('EmailValidator', () {
    final String errorText = 'invalid input message';
    final emailValidator = EmailValidator(errorText: errorText);

    test('validate with an invalid email will return $errorText', () {
      expect(errorText, emailValidator('invalidEmaial.com'));
    });

    test('validate with a valid email will return null', () {
      expect(null, emailValidator('me@email.com'));
    });
  });

  group('MaxLenghtValidator', () {
    final String errorText = 'invalid input message';
    final maxLengthValidator = MaxLengthValidator(max: 15, errorText: errorText);

    test('validate with a string greater then 15 charecters will return error text', () {
      expect(errorText, maxLengthValidator('text greater than 15 charecters'));
    });

    test('validate with a string equal or less then 15 charecters will return null', () {
      expect(null, maxLengthValidator('valid input'));
    });
  });

  group('MinLenghtValidator', () {
    final String errorText = 'invalid input message';
    final minLengthValidator = MinLengthValidator(min: 5, errorText: errorText);

    test('validate with a string < 5 charecters will return $errorText', () {
      expect(errorText, minLengthValidator('text'));
    });

    test('validate with a string >= 5 charecters will return null', () {
      expect(null, minLengthValidator('valid text'));
    });
  });

  group('LengthRangeValidator', () {
    final errorText = 'invalid input message';
    final lengthRangeValidator = LengthRangeValidator(min: 3, max: 10, errorText: errorText);

    test('validate with a string less then 3 or greater than 10 charecters will return error text', () {
      expect(errorText, lengthRangeValidator('sh'));
      expect(errorText, lengthRangeValidator('more than 10 characters message'));
    });

    test('validate with a string equal or less then 15 charecters will return null', () {
      expect(null, lengthRangeValidator('valid'));
    });
  });

  group('RangeValidator', () {
    final errorText = 'invalid input message';
    final rangeValidator = RangeValidator(min: 18, max: 32, errorText: errorText);

    test('validate with < 18 or > 32  will return error text', () {
      expect(errorText, rangeValidator('16'));
    });

    test('validate with >= 18 and <= 32 will return null', () {
      expect(null, rangeValidator('20'));
    });
  });

  group('PatternValidator', () {
    final errorText = 'invalid input message';
    final patternValidator = PatternValidator(pattern: r'(?=.*?[#?!@$%^&*-])', errorText: errorText);

    test('validate with no special char will return error text', () {
      expect(errorText, patternValidator('invalid'));
    });

    test('validate with at least one special char will return null', () {
      expect(null, patternValidator('*'));
    });
  });

  group('DateValidator', () {
    final errorText = 'invalid input message';
    final dateValidator = DateTextValidator(format: 'dd/mm/yyyy', errorText: errorText);

    test('validate with a date that does not matche the given format will return error text', () {
      expect(errorText, dateValidator('12-12-2020'));
    });

    test('validate with a date that matches the given format will return null', () {
      expect(null, dateValidator('12/12/2020'));
    });
  });

  group('MultiValidator', () {
    final String requiredErrorText = 'field is required';
    final String maxLengthErrorText = 'max lenght is 15';
    final multiValidator = MultiValidator(validators: [
      RequiredValidator<String>(errorText: requiredErrorText),
      MaxLengthValidator(max: 15, errorText: maxLengthErrorText),
    ]);

    test('validate with an empty value will return $requiredErrorText', () {
      expect(requiredErrorText, multiValidator(''));
    });

    test('validate with a string > 15 charecters will return $maxLengthErrorText', () {
      expect(maxLengthErrorText, multiValidator('a long text that contains more than 15 chars'));
    });

    test('validate with a string <= 15 charecters will return null', () {
      expect(null, multiValidator('short text'));
    });
  });
}
