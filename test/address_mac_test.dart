import 'package:test/test.dart';
import 'package:wake_on_lan/wake_on_lan.dart' show MACAddress;

const _octetDecimal = 78;
const _octetHex = '4E';

void main() {
  _constructors();
  _getters();
  _functions();
}

String _generateValidAddress({
  String octet = _octetHex,
  String delimiter = ':',
}) {
  final octets = List.filled(6, octet);
  return octets.join(delimiter);
}

void _constructors() {
  group('Constructor', () {
    test('Valid Instance', () {
      String address = '00:00:00:00:00:00';
      expect(MACAddress(address), equals(isA<MACAddress>()));
    });
    test('Invalid Instance: Empty String', () {
      String address = '';
      expect(() => MACAddress(address), throwsA(isA<FormatException>()));
    });
    test('Invalid Instance: Invalid String (Alpha)', () {
      String address = 'hello';
      expect(() => MACAddress(address), throwsA(isA<FormatException>()));
    });
    test('Invalid Instance: Invalid String (MAC structure, invalid octet)', () {
      String address = '00:00:00:00:FG:00';
      expect(() => MACAddress(address), throwsA(isA<FormatException>()));
    });
    test('Invalid Instance: Invalid String (MAC structure, invalid octet)', () {
      String address = '00:00:00:00:A:00';
      expect(() => MACAddress(address), throwsA(isA<FormatException>()));
    });
  });
}

void _getters() {
  group('Getter: bytes', () {
    List<int> bytes = List.filled(6, _octetDecimal);

    test('Default Delimiter', () {
      String address = _generateValidAddress();
      List<int> bytes = List.filled(6, _octetDecimal);

      expect(MACAddress(address).bytes, bytes);
    });

    test('Custom Delimiter (.)', () {
      String delimiter = '.';
      String address = _generateValidAddress(delimiter: delimiter);

      expect(MACAddress(address, delimiter: delimiter).bytes, bytes);
    });

    test('Custom Delimiter (|)', () {
      String delimiter = '|';
      String address = _generateValidAddress(delimiter: delimiter);

      expect(MACAddress(address, delimiter: delimiter).bytes, bytes);
    });

    test('Custom Delimiter (##)', () {
      String delimiter = '##';
      String address = _generateValidAddress(delimiter: delimiter);

      expect(MACAddress(address, delimiter: delimiter).bytes, bytes);
    });

    test('Custom Delimiter ([[]])', () {
      String delimiter = '[[]]';
      String address = _generateValidAddress(delimiter: delimiter);

      expect(MACAddress(address, delimiter: delimiter).bytes, bytes);
    });
  });
}

void _functions() {
  group('Static Function: .validate()', () {
    test('Valid String', () {
      String address = _generateValidAddress();
      final validation = MACAddress.validate(address);

      expect(validation.state, true);
      expect(validation.error, null);
    });
    test('Valid String, Custom Delimiter (|)', () {
      String delimiter = '|';
      String address = _generateValidAddress(delimiter: delimiter);
      final validation = MACAddress.validate(address, delimiter: delimiter);

      expect(validation.state, true);
      expect(validation.error, null);
    });
    test('Valid String, Custom Delimiter (##)', () {
      String delimiter = '##';
      String address = _generateValidAddress(delimiter: delimiter);
      final validation = MACAddress.validate(address, delimiter: delimiter);

      expect(validation.state, true);
      expect(validation.error, null);
    });
    test('Valid String, Custom Delimiter ([[]])', () {
      String delimiter = '[[]]';
      String address = _generateValidAddress(delimiter: delimiter);
      final validation = MACAddress.validate(address, delimiter: delimiter);

      expect(validation.state, true);
      expect(validation.error, null);
    });
    test('Null String', () {
      String? address;
      final validation = MACAddress.validate(address);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('Empty String', () {
      String address = '';
      final validation = MACAddress.validate(address);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('Invalid String (Alpha)', () {
      String address = 'hello';
      final validation = MACAddress.validate(address);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('Invalid String (MAC structure, invalid octet)', () {
      String address = '00:00:00:00:FG:00';
      final validation = MACAddress.validate(address);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('Invalid String (MAC structure, invalid octet)', () {
      String address = '00:00:00:00:A:00';
      final validation = MACAddress.validate(address);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('Invalid String (MAC structure, extra octet)', () {
      String address = '00:00:00:00:00:00:00';
      final validation = MACAddress.validate(address);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
  });
}
