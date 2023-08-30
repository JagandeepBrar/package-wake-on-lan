import 'dart:io';
import 'extensions/internet_address_type.dart';
import 'ip_address.dart';
import 'mac_address.dart';
import 'secure_on_password.dart';

const _maxPort = 65535;

class WakeOnLAN {
  final IPAddress ipAddress;
  final MACAddress macAddress;
  final SecureONPassword? secureOnPassword;
  final int port;

  WakeOnLAN._internal({
    required this.ipAddress,
    required this.macAddress,
    required this.secureOnPassword,
    required this.port,
  });

  /// Creates [WakeOnLAN] from an [IPAddress], [MACAddress]
  /// and optionally a [SecureONPassword] and [port].
  ///
  /// [password] is an optional parameter and should only be used with supported hardware.
  /// [port] by default is set to 9, the specification port for Wake-on-LAN functionality.
  factory WakeOnLAN(
    IPAddress ip,
    MACAddress mac, {
    SecureONPassword? password,
    int port = 9,
  }) {
    if (port > _maxPort) {
      throw StateError('Port must be under $_maxPort');
    }

    return WakeOnLAN._internal(
      ipAddress: ip,
      macAddress: mac,
      secureOnPassword: password,
      port: port,
    );
  }

  /// Assembles the magic packet for wake-on-LAN functionality.
  ///
  /// Total size of the wake-on-LAN magic packet is 102 bytes (816 bits)
  /// or 108 bytes (864 bits) with a SecureON password.
  ///
  /// The first 6 bytes (48 bits) are 0xFF (255) with the remaining 96 bytes (768 bits)
  /// as the 6 byte (48 bit) MAC address repeated 16 times as specified by the
  /// wake-on-LAN specification. If a SecureON password is supplied,
  /// 6 additional bytes (48 bits) are appended to the end of the magic packet.
  List<int> magicPacket() {
    List<int> data = [];

    for (int i = 0; i < 6; i++) {
      data.add(0xFF);
    }
    for (int j = 0; j < 16; j++) {
      data.addAll(macAddress.bytes);
    }
    if (secureOnPassword != null) {
      data.addAll(secureOnPassword!.bytes);
    }

    return data;
  }

  /// Sends the wake on LAN packets to the [IPAddress], [MACAddress], and [port] defined on creation.
  ///
  /// A [RawDatagramSocket] will be created and bound to any IPv4/IPv6 address and port 0.
  /// The socket will then be used to send the constructed packet to the [IPAddress] and [port].
  ///
  /// Increase [repeat] to send the magic packet [repeat] number of times at a delay of [repeatDelay].
  /// This can be used in the case you want to ensure the packet has be sent and received successfully.
  Future<void> wake({
    int repeat = 1,
    Duration repeatDelay = const Duration(milliseconds: 100),
  }) async {
    return RawDatagramSocket.bind(ipAddress.type.bindAddress, 0).then(
      (socket) async {
        final iAddr = InternetAddress(ipAddress.address, type: ipAddress.type);
        final packet = magicPacket();

        if (ipAddress.type == InternetAddressType.IPv4) {
          socket.broadcastEnabled = true;
        }

        for (int i = 0; i < repeat; i++) {
          if (i != 0) {
            await Future.delayed(repeatDelay);
          }
          socket.send(packet, iAddr, port);
        }

        socket.close();
      },
    );
  }
}
