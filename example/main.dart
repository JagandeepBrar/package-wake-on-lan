import 'package:wake_on_lan/wake_on_lan.dart';

void main() async {
  // Create the IPv4  broadcast address
  String ip = '192.168.1.255';
  String mac = 'AA:BB:CC:DD:EE:FF';

  // Validate that the two strings are formatted correctly
  if (!IPv4Address.validate(ip)) return;
  if (!MACAddress.validate(mac)) return;

  // Create the IPv4 and MAC objects
  IPv4Address ipv4Address = IPv4Address(ip);
  MACAddress macAddress = MACAddress(mac);

  // Send the WOL packet
  WakeOnLAN(ipv4Address, macAddress).wake();
}
