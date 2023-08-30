import 'dart:io';
import 'package:test/test.dart';
import 'package:wake_on_lan/wake_on_lan.dart' show IPAddress;

void main() {
  _constructors();
  _functions();
}

void _constructors() {
  test('It should default to IPv4 address type', () {
    String address = '192.168.1.1';
    final ip = IPAddress(address);

    expect(ip, equals(isA<IPAddress>()));
    expect(ip.type, equals(isA<InternetAddressType>()));
  });

  group('Constructor: IPv4', () {
    test('Valid Instance', () {
      String address = '192.168.1.1';
      expect(IPAddress(address), equals(isA<IPAddress>()));
    });

    test('Invalid Instance: Empty String', () {
      String address = '';
      expect(() => IPAddress(address), throwsA(isA<FormatException>()));
    });

    test('Invalid Instance: Invalid String (Alpha)', () {
      String address = 'hello';
      expect(() => IPAddress(address), throwsA(isA<FormatException>()));
    });
    test('Invalid Instance: Invalid String (MAC Structure, Invalid Octet)', () {
      String address = '192.168.1.256';
      expect(
        () => IPAddress(address, type: InternetAddressType.IPv4),
        throwsA(isA<FormatException>()),
      );
    });

    test('Invalid Instance: IPv6 Address', () {
      String address = '2001:0DB8:3333:4444:5555:6666:7777:8888';
      expect(() => IPAddress(address), throwsA(isA<FormatException>()));
    });
  });

  group('Constructor: IPv6', () {
    test('Valid Instance', () {
      String address = '2001:0DB8:3333:4444:5555:6666:7777:8888';
      expect(
        IPAddress(address, type: InternetAddressType.IPv6),
        equals(isA<IPAddress>()),
      );
    });

    test('Invalid Instance: Empty String', () {
      String address = '';
      expect(
        () => IPAddress(address, type: InternetAddressType.IPv6),
        throwsA(isA<FormatException>()),
      );
    });
    test('Invalid Instance: Invalid String (Alpha)', () {
      String address = 'hello';
      expect(
        () => IPAddress(address, type: InternetAddressType.IPv6),
        throwsA(isA<FormatException>()),
      );
    });
    test('Invalid Instance: Invalid String (Hex Structure, Invalid Octet)', () {
      String address = '2001:0BD88:3333:4444:5555:6666:7777:8888';
      expect(
        () => IPAddress(address, type: InternetAddressType.IPv6),
        throwsA(isA<FormatException>()),
      );
    });

    test('Invalid Instance: IPv4 Address', () {
      String address = '192.168.1.1';
      expect(
        () => IPAddress(address, type: InternetAddressType.IPv6),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('Factory: fromHost', () {
    test('IPv4: Valid Host', () async {
      String host = 'pub.dev';
      expect(
        await IPAddress.fromHost(host, type: InternetAddressType.IPv4),
        isA<IPAddress>(),
      );
    });

    test('IPv6: Valid Host', () async {
      String host = 'pub.dev';
      expect(
        await IPAddress.fromHost(host, type: InternetAddressType.IPv6),
        isA<IPAddress>(),
      );
    });

    test('Should throw an invalid host', () async {
      String host = 'some-invalid-host.abcdef';
      expect(
        () async => await IPAddress.fromHost(host),
        throwsA(isA<SocketException>()),
      );
    });
  });
}

void _functions() {
  group('Static Function: .validate()', () {
    test('IPv4: Valid String', () {
      String address = '192.168.1.1';
      final validation = IPAddress.validate(address);

      expect(validation.state, true);
      expect(validation.error, null);
    });
    test('IPv4: Null String', () {
      String? address;
      final validation = IPAddress.validate(address);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('IPv4: Empty String', () {
      String address = '';
      final validation = IPAddress.validate(address);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('IPv4: Invalid String (Alpha)', () {
      String address = 'hello';
      final validation = IPAddress.validate(address);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('IPv4: Invalid String (IPv4 structure, invalid octet)', () {
      String address = '192.168.1.256';
      final validation = IPAddress.validate(address);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });

    test('IPv6: Invalid String (Valid IPv6 address)', () {
      String address = '2001:0DB8:3333:4444:5555:6666:7777:8888';
      final validation = IPAddress.validate(address);

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });

    test('IPv6: Valid String', () {
      String address = '2001:0DB8:3333:4444:5555:6666:7777:8888';
      final validation = IPAddress.validate(
        address,
        type: InternetAddressType.IPv6,
      );

      expect(validation.state, true);
      expect(validation.error, null);
    });
    test('IPv6: Null String', () {
      String? address;
      final validation = IPAddress.validate(
        address,
        type: InternetAddressType.IPv6,
      );

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('IPv6: Empty String', () {
      String address = '';
      final validation = IPAddress.validate(
        address,
        type: InternetAddressType.IPv6,
      );

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('IPv6: Invalid String (Alpha)', () {
      String address = 'hello';
      final validation = IPAddress.validate(
        address,
        type: InternetAddressType.IPv6,
      );

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
    test('IPv6: Invalid String (IPv4 structure, invalid octet)', () {
      String address = '2001:0DB88:3333:4444:5555:6666:7777:8888';
      final validation = IPAddress.validate(
        address,
        type: InternetAddressType.IPv6,
      );

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });

    test('IPv6: Invalid String (Valid IPv4 address)', () {
      String address = '192.168.1.1';
      final validation = IPAddress.validate(
        address,
        type: InternetAddressType.IPv6,
      );

      expect(validation.state, false);
      expect(validation.error, isA<FormatException>());
    });
  });
}
