import 'package:wake_on_lan/wake_on_lan.dart' show MACAddress;
import 'package:test/test.dart';

void main() {
  _getters();
  _functionValidate();
  _constructor();
}

String _generateValidAddress({
  String octet = '00',
  String delimiter = ':',
}) {
  final octets = List.filled(6, octet);
  return octets.join(delimiter);
}

void _getters() {
  group('Getter: bytes', () {
    test('Default Delimiter', () {
      String address = _generateValidAddress(octet: '4E');
      List<int> bytes = List.filled(6, 78);
      MACAddress mac = MACAddress(address);
      expect(mac.bytes, bytes);
    });

    test('Custom Delimiter (|)', () {
      String delimiter = '|';
      String address = _generateValidAddress(octet: '4E', delimiter: delimiter);
      List<int> bytes = List.filled(6, 78);
      MACAddress mac = MACAddress(address, delimiter: delimiter);
      expect(mac.bytes, bytes);
    });

    test('Custom Delimiter (##)', () {
      String delimiter = '##';
      String address = _generateValidAddress(octet: '4E', delimiter: delimiter);
      List<int> bytes = List.filled(6, 78);
      MACAddress mac = MACAddress(address, delimiter: delimiter);
      expect(mac.bytes, bytes);
    });

    test('Custom Delimiter ([[]])', () {
      String delimiter = '[[]]';
      String address = _generateValidAddress(octet: '4E', delimiter: delimiter);
      List<int> bytes = List.filled(6, 78);
      MACAddress mac = MACAddress(address, delimiter: delimiter);
      expect(mac.bytes, bytes);
    });
  });
}

void _functionValidate() {
  group('Function: .validate()', () {
    test('Valid String', () {
      String address = _generateValidAddress();
      expect(MACAddress.validate(address), true);
    });
    test('Valid String, Custom Delimiter (|)', () {
      String delimiter = '|';
      String address = _generateValidAddress(delimiter: delimiter);
      expect(MACAddress.validate(address, delimiter: delimiter), true);
    });
    test('Valid String, Custom Delimiter (##)', () {
      String delimiter = '##';
      String address = _generateValidAddress(delimiter: delimiter);
      expect(MACAddress.validate(address, delimiter: delimiter), true);
    });
    test('Valid String, Custom Delimiter ([[]])', () {
      String delimiter = '[[]]';
      String address = _generateValidAddress(delimiter: delimiter);
      expect(MACAddress.validate(address, delimiter: delimiter), true);
    });
    test('Null String', () {
      String? address;
      expect(MACAddress.validate(address), false);
    });
    test('Empty String', () {
      String address = '';
      expect(MACAddress.validate(address), false);
    });
    test('Invalid String (Alpha)', () {
      String address = 'hello';
      expect(MACAddress.validate(address), false);
    });
    test('Invalid String (MAC structure, invalid octet)', () {
      String address = '00:00:00:00:FG:00';
      expect(MACAddress.validate(address), false);
    });
    test('Invalid String (MAC structure, invalid octet)', () {
      String address = '00:00:00:00:A:00';
      expect(MACAddress.validate(address), false);
    });
    test('Invalid String (MAC structure, extra octet)', () {
      String address = '00:00:00:00:00:00:00';
      expect(MACAddress.validate(address), false);
    });
  });
}

void _constructor() {
  group('Unnamed Factory Constructor', () {
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
