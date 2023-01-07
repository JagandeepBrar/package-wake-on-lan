# Wake-on-LAN

[![Pubdev][pubdev-shield]][pubdev]
![License][license-shield]

Dart library package to easily send [Wake-on-LAN](https://en.wikipedia.org/wiki/Wake-on-LAN) magic packets to devices on your local network.

## Getting Started

`wake_on_lan` has three core classes for functionality, `IPv4Address`, `MACAddress`, and `WakeOnLAN`. All classes are exported in the main file, to import:

```dart
import 'package:wake_on_lan/wake_on_lan.dart';
```

#### Create an IPv4 Address

`IPv4Address` is a helper class to ensure that your IPv4 address has been formatted correctly.

The class has a static function, `validate(String address)` which allows easy validation that an IPv4 address string is correctly formatted.

Create an `IPv4Address` instance by using `IPv4Address(address)` where `address` is a string representation of the broadcast address of the network ([easily find your broadcast address using this tool](https://remotemonitoringsystems.ca/broadcast.php)). The factory will call the validation function mentioned above, but will throw a `FormatException` on a poorly constructed string, so it is recommended to validate it first.

```dart
String address = '192.168.1.1';
if(IPv4Address.validate(address)) {
    IPv4Address ipv4 = IPv4Address(address);
    //Continue execution
} else {
    // Handle invalid address case
}
```

#### Create MAC Address

`MACAddress` is a helper class to ensure that your MAC address has been formatted correctly.

The class has a static function, `validate(String address)` which allows easy validation that a MAC address string is correctly formatted.

Create a `MACAddress` instance by using `MACAddress(address)` where `address` is a string representation of the address. The factory will call the validation function mentioned above, but will throw a `FormatException` on a poorly constructed string, so it is recommended to validate it first.

```dart
String address = 'AA:BB:CC:DD:EE:FF';
if(MACAddress.validate(address)) {
    MACAddress mac = MACAddress(address);
    //Continue execution
} else {
    // Handle invalid address case
}
```

You can optionally pass in a custom `delimiter` when the octets are not separated by colons (:). Ensure you pass the custom `delimiter` to both the `validate` function and the factory constructor when instantiating a `MACAddress` in this scenario.

```dart
String delimiter = '#';
String address = 'AA#BB#CC#DD#EE#FF';
if(MACAddress.validate(address, delimiter: delimiter)) {
    MACAddress mac = MACAddress(address, delimiter: delimiter);
    //Continue execution
} else {
    // Handle invalid address case
}
```

#### Sending Wake-on-LAN Packet

`WakeOnLAN` is the class to handle sending the actual wake-on-LAN magic packet to your network.

Create a `WakeOnLAN` instance by using `WakeOnLAN(ipv4, mac, { port })` where `ipv4` is an `IPv4Address` instance, `mac` is a `MACAddress` instance, and `port` is an optional integer parameter for which port the packet should be sent over (defaulted to the specification standard port, 9).

Once created, call the function `wake()` on the `WakeOnLAN` object to send the packet.

```dart
String mac = 'AA:BB:CC:DD:EE:FF';
String ipv4 = '192.168.1.255';
if(MACAddress.validate(mac) && IPv4Address.validate(ipv4)) {
    MACAddress macAddress = MACAddress(mac);
    IPv4Address ipv4Address = IPv4Address(ipv4);
    WakeOnLAN wol = WakeOnLAN(ipv4Address, macAddress);
    await wol.wake().then(() => print('sent'));
}
```

You can also optionally create a `WakeOnLAN` instance with IPv4 and MAC address strings with the `withString(ipv4, mac, { port })` factory constructor. Note that the MAC address does not support custom delimiters with this factory and must be separated by colons (:).

```dart
String mac = 'AA:BB:CC:DD:EE:FF';
String ipv4 = '192.168.1.255';
WakeOnLAN wol = WakeOnLAN.fromString(ipv4, mac);
await wol.wake().then(() => print('sent'));
}
```

## Web Support

Wake on LAN functionality utilizes [User Datagram Protocol (UDP)](https://en.wikipedia.org/wiki/User_Datagram_Protocol) which is not available in the browser because of security constraints.

## Notes

Because wake-on-LAN packets are sent over UDP, beyond the successful creation of a datagram socket and sending the data over the network, there is no way to confirm that the machine has been awoken beyond pinging the machine after waking it (**This functionality is not implemented in this package**). This is because of the nature of UDP sockets which do not need to establish the connection for the data to be sent.

[license-shield]: https://img.shields.io/github/license/RoninComputer/dart-wake-on-lan?style=for-the-badge
[pubdev]: https://pub.dev/packages/wake_on_lan/
[pubdev-shield]: https://img.shields.io/pub/v/wake_on_lan.svg?style=for-the-badge
