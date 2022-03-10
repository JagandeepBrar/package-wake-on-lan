import 'dart:io';
import './address_ipv4.dart';
import './address_mac.dart';

/// [WakeOnLAN] handles sending the actual wake-on-LAN magic packet to your network.
class WakeOnLAN {
  static const _maxPort = 65535;
  final IPv4Address _ipv4Address;
  final MACAddress _macAddress;
  final int _port;

  WakeOnLAN._internal(this._ipv4Address, this._macAddress, this._port);

  /// Creates [WakeOnLAN] from an [IPv4Address], [MACAddress], and optionally defined [port].
  ///
  /// The port is defaulted to 9, the standard port for Wake on LAN functionality.
  factory WakeOnLAN(IPv4Address ipv4, MACAddress mac, {int port = 9}) {
    assert(port <= _maxPort);
    return WakeOnLAN._internal(ipv4, mac, port);
  }

  /// MAC Address string from [MACAddress].
  String get macAddress => _macAddress.address;

  /// IPv4 Address string from [IPv4Address].
  String get ipv4Address => _ipv4Address.address;

  /// Port used for wake-on-LAN packet.
  int get port => _port;

  /// Assembles the magic packet for wake-on-LAN functionality.
  ///
  /// Total size of the wake-on-LAN magic packet is 102 bytes, or 816 bits.
  ///
  /// First 6 bytes (48 bits) are 0xFF (255), as specified by the wake-on-LAN specification.
  /// Remaining 96 bytes (768 bits) is the 6 byte (48 bit) MAC address repeated 16 times.
  List<int> magicPacket() {
    List<int> data = [];

    for (int i = 0; i < 6; i++) {
      data.add(0xFF);
    }
    for (int j = 0; j < 16; j++) {
      data.addAll(_macAddress.bytes);
    }

    return data;
  }

  /// Sends the wake on LAN packets to the [IPv4Address], [MACAddress], and [port] defined on creation.
  ///
  /// A [RawDatagramSocket] will be created and bound to any IPv4 address and port 0.
  /// The socket will then be used to send the constructed packet to the address in [IPv4Address] and [port].
  Future<void> wake() async {
    return RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
      final addr = _ipv4Address.address;
      final iAddr = InternetAddress(addr, type: InternetAddressType.IPv4);

      socket.broadcastEnabled = true;
      socket.send(magicPacket(), iAddr, _port);
      socket.close();
    });
  }
}
