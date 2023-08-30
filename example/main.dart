import 'package:wake_on_lan/wake_on_lan.dart';

void main() async {
  String ipv4 = '192.168.1.255';
  String mac = 'AA:BB:CC:DD:EE:FF';

  // Validate that the IP address is correctly formatted
  final ipValidation = IPAddress.validate(ipv4);
  if (!ipValidation.state) {
    throw ipValidation.error!;
  }

  // Validate that the MAC address is correctly formatted
  final macValidation = MACAddress.validate(mac);
  if (!macValidation.state) {
    throw macValidation.error!;
  }

  // Create the IP and MAC addresses
  IPAddress ipv4Address = IPAddress(ipv4);
  MACAddress macAddress = MACAddress(mac);

  // Send the Wake-on-LAN packet
  WakeOnLAN(ipv4Address, macAddress).wake();
}
