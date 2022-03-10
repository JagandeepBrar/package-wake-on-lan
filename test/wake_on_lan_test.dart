import 'package:wake_on_lan/wake_on_lan.dart';
import 'package:test/test.dart';

void main() {
  _getters();
  _constructor();
  _functionMagicPacket();
  _functionWake();
}

void _getters() {
  group('Getters', () {
    MACAddress mac = MACAddress('AA:BB:CC:DD:EE:FF');
    IPv4Address ipv4 = IPv4Address('192.168.1.1');
    test('macAddress', () {
      WakeOnLAN wol = WakeOnLAN(ipv4, mac);
      expect(wol.macAddress, mac.address);
    });
    test('ipv4Address', () {
      WakeOnLAN wol = WakeOnLAN(ipv4, mac);
      expect(wol.ipv4Address, ipv4.address);
    });
    test('port (undefined)', () {
      WakeOnLAN wol = WakeOnLAN(ipv4, mac);
      expect(wol.port, 9);
    });
    test('port (defined)', () {
      int port = 1234;
      WakeOnLAN wol = WakeOnLAN(ipv4, mac, port: port);
      expect(wol.port, port);
    });
  });
}

void _constructor() {
  MACAddress mac = MACAddress('AA:BB:CC:DD:EE:FF');
  IPv4Address ipv4 = IPv4Address('192.168.1.1');
  group('Constructor', () {
    test('Valid Instance: port undefined', () {
      expect(WakeOnLAN(ipv4, mac), isA<WakeOnLAN>());
    });
    test('Valid Instance: port defined', () {
      expect(WakeOnLAN(ipv4, mac, port: 1234), isA<WakeOnLAN>());
    });
    test('Invalid Instance: port defined, invalid number', () {
      expect(() => WakeOnLAN(ipv4, mac, port: 70000),
          throwsA(isA<AssertionError>()));
    });
  });
}

void _functionWake() {
  group('Function: .wake()', () {
    MACAddress mac = MACAddress('A4:83:E7:0D:7F:4F');
    IPv4Address ipv4 = IPv4Address('192.168.99.255');
    test('Ensure it runs', () async {
      try {
        await WakeOnLAN(ipv4, mac).wake();
      } catch (error) {
        fail(error.toString());
      }
    });
  });
}

void _functionMagicPacket() {
  group('Function: .magicPacket()', () {
    MACAddress mac = MACAddress('AA:BB:CC:DD:EE:FF');
    IPv4Address ipv4 = IPv4Address('192.168.1.1');
    const _prebuiltPacket = [
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
    test('Check if the array is built correctly', () {
      WakeOnLAN wol = WakeOnLAN(ipv4, mac);
      expect(wol.magicPacket(), _prebuiltPacket);
    });
  });
}
