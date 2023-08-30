import 'package:test/test.dart';
import 'package:wake_on_lan/wake_on_lan.dart';

void main() {
  _constructors();
  _functions();
}

void _constructors() {
  MACAddress mac = MACAddress('AA:BB:CC:DD:EE:FF');
  IPAddress ip = IPAddress('192.168.1.1');

  group('Constructor', () {
    test('Valid Instance: port undefined', () {
      final wakeOnLan = WakeOnLAN(ip, mac);

      expect(wakeOnLan, isA<WakeOnLAN>());
      expect(wakeOnLan.port, 9);
    });
    test('Valid Instance: port defined', () {
      final port = 1234;
      final wakeOnLan = WakeOnLAN(ip, mac, port: port);

      expect(wakeOnLan, isA<WakeOnLAN>());
      expect(wakeOnLan.port, port);
    });
    test('Invalid Instance: port defined, invalid number', () {
      expect(
        () => WakeOnLAN(ip, mac, port: 70000),
        throwsA(isA<StateError>()),
      );
    });
  });
}

void _functions() {
  group('Function: .wake()', () {
    MACAddress mac = MACAddress('A4:83:E7:0D:7F:4F');
    IPAddress ip = IPAddress('192.168.99.255');
    test('Should run successfully', () async {
      try {
        await WakeOnLAN(ip, mac).wake();
      } catch (error) {
        fail(error.toString());
      }
    });
  });

  group('Function: .magicPacket()', () {
    MACAddress mac = MACAddress('AA:BB:CC:DD:EE:FF');
    IPAddress ip = IPAddress('192.168.1.1');
    const prebuiltPacket = [
      // 6 0xFF (255) bytes
      255, 255, 255, 255, 255, 255,
      // 16 instances of the MAC Address AA:BB:CC:DD:EE:FF
      // AA = 170, BB = 187, CC = 204, DD = 221, EE = 238, FF = 255
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
      170, 187, 204, 221, 238, 255,
    ];
    test('Should build the packet in the correct structure', () {
      WakeOnLAN wakeOnLan = WakeOnLAN(ip, mac);
      expect(wakeOnLan.magicPacket(), prebuiltPacket);
    });

    test('Should append the SecureON password if given', () {
      final password = '11:22:33:44:55:66';
      final secureOn = SecureONPassword(password);
      final wakeOnLan = WakeOnLAN(ip, mac, password: secureOn);

      expect(wakeOnLan.magicPacket(), [
        ...prebuiltPacket,
        ...secureOn.bytes,
      ]);
    });
  });
}
