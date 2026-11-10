import 'package:flutter_test/flutter_test.dart';
import 'package:code_test/core/constants/app_constants.dart';
import 'package:code_test/features/auth/domain/validators/auth_validators.dart';

void main() {
  group('PhoneValidator Tests', () {
    test('normalizes 09254135592 to +959254135592', () {
      final result = PhoneValidator.validate('09254135592');
      expect(result.isValid, isTrue);
      expect(result.normalizedPhone, equals('+959254135592'));
    });

    test('strips spaces and dashes properly', () {
      final result = PhoneValidator.validate(' 09-254 135-592 ');
      expect(result.isValid, isTrue);
      expect(result.normalizedPhone, equals('+959254135592'));
    });

    test('accepts number already starting with +95', () {
      final result = PhoneValidator.validate('+959254135592');
      expect(result.isValid, isTrue);
      expect(result.normalizedPhone, equals('+959254135592'));
    });

    test('rejects number not starting with 9 after prefix', () {
      final result = PhoneValidator.validate('07254135592');
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('valid Myanmar number'));
    });

    test('rejects numbers too short (< 7 digits after 9)', () {
      final result = PhoneValidator.validate('0912345');
      expect(result.isValid, isFalse);
    });

    test('rejects numbers too long (> 9 digits after 9)', () {
      final result = PhoneValidator.validate('0912345678901');
      expect(result.isValid, isFalse);
    });

    test('rejects empty input', () {
      final result = PhoneValidator.validate('');
      expect(result.isValid, isFalse);
      expect(result.errorMessage, equals('Phone number is required'));
    });
  });

  group('NameValidator Tests', () {
    test('validates standard English first name', () {
      expect(NameValidator.validateFirstName('Ye Min'), isNull);
    });

    test('validates Myanmar script in first name', () {
      // Myanmar name: "သီဟ"
      expect(NameValidator.validateFirstName('သီဟ'), isNull);
    });

    test('rejects empty or whitespace-only first name', () {
      expect(NameValidator.validateFirstName('   '), equals('First name is required'));
    });

    test('rejects digits in first name', () {
      expect(NameValidator.validateFirstName('John2'), equals('First name cannot contain numbers'));
    });

    test('rejects names longer than 50 characters', () {
      final longName = 'A' * 51;
      expect(NameValidator.validateFirstName(longName), contains('cannot exceed 50 characters'));
    });

    test('last name is optional (empty string is valid)', () {
      expect(NameValidator.validateLastName(''), isNull);
      expect(NameValidator.validateLastName('   '), isNull);
    });

    test('last name validates correctly when provided', () {
      expect(NameValidator.validateLastName('Phyoe Win'), isNull);
      expect(NameValidator.validateLastName('အောင်'), isNull);
      expect(NameValidator.validateLastName('Smith99'), contains('cannot contain numbers'));
    });
  });

  group('DobValidator Tests', () {
    final referenceDate = DateTime(2026, 11, 9);

    test('accepts valid date for adult (e.g., 1980/5/1)', () {
      final error = DobValidator.validate(
        day: 1,
        month: 5,
        year: 1980,
        referenceDate: referenceDate,
      );
      expect(error, isNull);
    });

    test('rejects 31 April (April only has 30 days)', () {
      final error = DobValidator.validate(
        day: 31,
        month: 4,
        year: 2000,
        referenceDate: referenceDate,
      );
      expect(error, contains('Invalid day for selected month'));
    });

    test('accepts 29 Feb on leap year (e.g., 2000)', () {
      final error = DobValidator.validate(
        day: 29,
        month: 2,
        year: 2000,
        referenceDate: referenceDate,
      );
      expect(error, isNull);
    });

    test('rejects 29 Feb on non-leap year (e.g., 2001)', () {
      final error = DobValidator.validate(
        day: 29,
        month: 2,
        year: 2001,
        referenceDate: referenceDate,
      );
      expect(error, contains('Invalid day for selected month'));
    });

    test('rejects future date', () {
      final error = DobValidator.validate(
        day: 1,
        month: 1,
        year: 2027,
        referenceDate: referenceDate,
      );
      expect(error, contains('cannot be in the future'));
    });

    test('rejects user younger than minAge (${AppConstants.minAgeYears})', () {
      // Reference is Nov 9, 2026. A user born in 2015 is 11 years old.
      final error = DobValidator.validate(
        day: 9,
        month: 11,
        year: 2015,
        referenceDate: referenceDate,
      );
      expect(error, contains('must be at least 13 years old'));
    });
  });

  group('OtpValidator Tests', () {
    test('accepts 123456 as valid test code', () {
      expect(OtpValidator.validate('123456'), isTrue);
    });

    test('rejects any other code', () {
      expect(OtpValidator.validate('654321'), isFalse);
      expect(OtpValidator.validate('000000'), isFalse);
      expect(OtpValidator.validate('12345'), isFalse);
    });
  });
}
