import 'dart:io';

import './address_ipv4.dart';
import './address_mac.dart';

/// [WakeOnLAN] handles sending the actual wake-on-LAN magic packet to your network.
class WakeOnLAN {
  static const _maxPort = 65535;
  final IPv4Address ipv4Address;
  final MACAddress macAddress;
  final int port;

  WakeOnLAN._internal(this.ipv4Address, this.macAddress, this.port);

  /// Creates [WakeOnLAN] from an [IPv4Address], [MACAddress], and optionally defined [port].
  ///
  /// The port is defaulted to 9, the standard port for Wake on LAN functionality.
  factory WakeOnLAN(
    IPv4Address ipv4,
    MACAddress mac, {
    int port = 9,
  }) {
    assert(port <= _maxPort);
    return WakeOnLAN._internal(ipv4, mac, port);
  }

  /// Creates [WakeOnLAN] from an IPv4 address string and MAC address string, and optionally defined [port].
  ///
  /// This allows directly creating the class without needing to instantiate [IPv4Address] and [MACAddress] instances.
  /// The MAC address must be delimited with colons (:).
  ///
  /// The port is defaulted to 9, the standard port for Wake on LAN functionality.
  factory WakeOnLAN.fromString(
    String ipv4,
    String mac, {
    int port = 9,
  }) {
    assert(port <= _maxPort);
    return WakeOnLAN._internal(
      IPv4Address(ipv4),
      MACAddress(mac),
      port,
    );
  }

  /// Assembles the magic packet for wake-on-LAN functionality.
  ///
  /// Total size of the wake-on-LAN magic packet is 102 bytes, or 816 bits.
  ///
  /// First 6 bytes (48 bits) are 0xFF (255) with the remaining 96 bytes (768 bits) as the 6 byte (48 bit)
  /// MAC address repeated 16 times as specified by the wake-on-LAN specification.
  List<int> magicPacket() {
    List<int> data = [];

    for (int i = 0; i < 6; i++) {
      data.add(0xFF);
    }
    for (int j = 0; j < 16; j++) {
      data.addAll(macAddress.bytes);
    }

    return data;
  }

  /// Sends the wake on LAN packets to the [IPv4Address], [MACAddress], and [port] defined on creation.
  ///
  /// A [RawDatagramSocket] will be created and bound to any IPv4 address and port 0.
  /// The socket will then be used to send the constructed packet to the address in [IPv4Address] and [port].
  ///
  /// Increase the [repeat] times in case you want to ensure the packet can be sent successfully.
  Future<void> wake({
    int repeat = 1,
  }) async {
    return RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then(
      (socket) async {
        final addr = ipv4Address.address;
        final iAddr = InternetAddress(addr, type: InternetAddressType.IPv4);

        socket.broadcastEnabled = true;
        for (int i = 0; i < repeat; i++) {
          if (i != 0) {
            // Manually await for 100 milliseconds.
            await Future.delayed(const Duration(milliseconds: 100));
          }
          socket.send(magicPacket(), iAddr, port);
        }
        socket.close();
      },
    );
  }
}
