import 'package:test/test.dart';
import 'package:wake_on_lan/wake_on_lan.dart' show SecureONPassword;

const _octetDecimal = 78;
const _octetHex = '4E';

void main() {
  _constructors();
  _getters();
  _functions();
}

String _generateValidPassword({
  String octet = _octetHex,
  String delimiter = ':',
}) {
  final octets = List.filled(6, octet);
  return octets.join(delimiter);
}

void _constructors() {
  group('Constructor', () {
    test('Valid Instance', () {
      String password = '00:00:00:00:00:00';
      expect(SecureONPassword(password), equals(isA<SecureONPassword>()));
    });
    test('Invalid Instance: Empty String', () {
      String password = '';
      expect(() => SecureONPassword(password), throwsA(isA<FormatException>()));
    });
    test('Invalid Instance: Invalid String (Alpha)', () {
      String password = 'hello';
      expect(() => SecureONPassword(password), throwsA(isA<FormatException>()));
    });
    test('Invalid Instance: Invalid String (Hex structure, invalid octet)', () {
      String password = '00:00:00:00:FG:00';
      expect(() => SecureONPassword(password), throwsA(isA<FormatException>()));
    });
    test('Invalid Instance: Invalid String (Hex structure, invalid octet)', () {
      String password = '00:00:00:00:A:00';
      expect(() => SecureONPassword(password), throwsA(isA<FormatException>()));
    });
  });
}

void _getters() {
  group('Getter: bytes', () {
    List<int> bytes = List.filled(6, _octetDecimal);

    test('Default Delimiter', () {
      String password = _generateValidPassword();
      List<int> bytes = List.filled(6, _octetDecimal);

      expect(SecureONPassword(password).bytes, bytes);
    });

    test('Custom Delimiter (.)', () {
      String delimiter = '.';
      String password = _generateValidPassword(delimiter: delimiter);

      expect(SecureONPassword(password, delimiter: delimiter).bytes, bytes);
    });

    test('Custom Delimiter (|)', () {
      String delimiter = '|';
      String password = _generateValidPassword(delimiter: delimiter);

      expect(SecureONPassword(password, delimiter: delimiter).bytes, bytes);
    });

    test('Custom Delimiter (##)', () {
      String delimiter = '##';
      String password = _generateValidPassword(delimiter: delimiter);

      expect(SecureONPassword(password, delimiter: delimiter).bytes, bytes);
    });

    test('Custom Delimiter ([[]])', () {
      String delimiter = '[[]]';
      String password = _generateValidPassword(delimiter: delimiter);

      expect(SecureONPassword(password, delimiter: delimiter).bytes, bytes);
    });
  });
}

void _functions() {
  group('Static Function: .validate()', () {
    test('Valid String', () {
      String password = _generateValidPassword();
      final validation = SecureONPassword.validate(password);

      expect(validation.state, true);
      expect(validation.error, null);
    });
    test('Valid String, Custom Delimiter (|)', () {
      String delimiter = '|';
      String password = _generateValidPassword(delimiter: delimiter);
      final validation =
          SecureONPassword.validate(password, delimiter: delimiter);

      expect(validation.state, true);
      expect(validation.error, null);
    });
    test('Valid String, Custom Delimiter (##)', () {
      String delimiter = '##';
      String password = _generateValidPassword(delimiter: delimiter);
      final validation =
          SecureONPassword.validate(password, delimiter: delimiter);

      expect(validation.state, true);
      expect(validation.error, null);
    });
    test('Valid String, Custom Delimiter ([[]])', () {
      String delimiter = '[[]]';
      String password = _generateValidPassword(delimiter: delimiter);
      final validation =
          SecureONPassword.validate(password, delimiter: delimiter);

      expect(validation.state, true);
      expect(validation.error, null);
    });
    test('Null String', () {
      String? password;
      final validation = SecureONPassword.validate(password);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('Empty String', () {
      String password = '';
      final validation = SecureONPassword.validate(password);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('Invalid String (Alpha)', () {
      String password = 'hello';
      final validation = SecureONPassword.validate(password);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('Invalid String (Hex structure, invalid octet)', () {
      String password = '00:00:00:00:FG:00';
      final validation = SecureONPassword.validate(password);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('Invalid String (Hex structure, invalid octet)', () {
      String password = '00:00:00:00:A:00';
      final validation = SecureONPassword.validate(password);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('Invalid String (Hex structure, extra octet)', () {
      String password = '00:00:00:00:00:00:00';
      final validation = SecureONPassword.validate(password);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
  });
}
