# Wake-on-LAN

[![pub.dev][image-pubdev]][link-pubdev]
![license][image-license]

Dart library package to easily send [Wake-on-LAN][link-wiki-wol] magic packets to devices on your local network. The package currently supports:

- IPv4 and IPv6 Addresses
- SecureON Password Authentication
- Optional Repeated Packet Sending

## Getting Started

```dart
import 'package:wake_on_lan/wake_on_lan.dart';
```

#### 1. Create an IP Address Instance

`IPAddress` has a static function, `validate(address, { type })`, which allows for easy validation that an IP address string is correctly formatted. An IPv6 address can be used but `type` must be set to `InternetAddressType.IPv6` during validation of the address and construction of the class.

Create an `IPAddress` instance by using `IPAddress(address, { type })` where `address` is a string representation of the [broadcast address][link-broadcast-tool] (IPv4) or multicast address (IPv6) of the network and `type` is the internet address type (defaults to `InternetAddressType.IPv4`). The constructor will call the validation function mentioned above but will throw the exception thrown when validating the poorly constructed address string, so it is recommended to validate it first.

```dart
String ipv4 = '192.168.1.255';

final validation = IPAddress.validate(ipv4);
if(validation.state) {
  IPAddress ip = IPAddress(ipv4);
  // Continue execution
} else {
  // Handle invalid address case - access the error that was thrown during validation via `validation.error`.
}
```

You can also optionally create an `IPAddress` instance using the `fromHost(host, { type, hostPredicate })` static method which will lookup the host and use the associated IP address. By default the function will select and return the first address returned within the lookup but `hostPredicate` can be set to choose which host address is selected and returned.

#### 2. Create MAC Address Instance

`MACAddress` has a static function, `validate(String address, { delimiter })`, which allows easy validation that a MAC address string is correctly formatted.

Create a `MACAddress` instance by using `MACAddress(address, { delimiter })` where `address` is a string representation of the address. The constructor will call the validation function mentioned above but will throw the exception thrown when validating the poorly constructed address string, so it is recommended to validate it first.

```dart
String address = 'AA:BB:CC:DD:EE:FF';

final validation = MACAddress.validate(address);
if(validation.state) {
  MACAddress mac = MACAddress(address);
  //Continue execution
} else {
  // Handle invalid address case - access the error that was thrown during validation via `validation.error`.
}
```

You can optionally set a custom `delimiter` when the octets are not separated by colons (:). Ensure you pass the custom `delimiter` to both the `validate` function and the factory constructor when instantiating a `MACAddress` in this scenario.

```dart
String delimiter = '#';
String address = 'AA#BB#CC#DD#EE#FF';

final validation = MACAddress.validate(address, delimiter: delimiter);
if(validation.state) {
  MACAddress mac = MACAddress(address, delimiter: delimiter);
  //Continue execution
} else {
    // Handle invalid address case - access the error that was thrown during validation via `validation.error`.
}
```

#### 3. (Optional) Create a SecureON Password Instance

Some newer devices support Wake-on-LAN's SecureON password functionality, which involves including a 6-octet hex password at the end of the magic packet that is validated before waking the machine.

`SecureONPassword` has a static function, `validate(String password, { delimiter })`, which allows easy validation that a SecureON password string is correctly formatted.

Create a `SecureONPassword` instance by using `SecureONPassword(password, { delimiter })` where `password` is a string representation of the SecureON password. The constructor will call the validation function mentioned above but will throw the exception thrown when validating the poorly constructed password string, so it is recommended to validate it first.

```dart
String password = '00:11:22:33:44:55';

final validation = SecureONPassword.validate(password);
if(validation.state) {
  SecureONPassword secureOnPassword = SecureONPassword(password);
  //Continue execution
} else {
  // Handle invalid password case - access the error that was thrown during validation via `validation.error`.
}
```

You can optionally pass in a custom `delimiter` when the octets are not separated by colons (:). Ensure you pass the custom `delimiter` to both the `validate` function and the factory constructor when instantiating a `SecureONPassword` in this scenario.

```dart
String delimiter = '#';
String password = '00#11#22#33#44#55';

final validation = SecureONPassword.validate(password, delimiter: delimiter);
if(validation.state) {
  SecureONPassword secureOnPassword = SecureONPassword(password, delimiter: delimiter);
  //Continue execution
} else {
  // Handle invalid password case - access the error that was thrown during validation via `validation.error`.
}
```

#### 4. Sending the Wake-on-LAN Packet

Create a `WakeOnLAN` instance by using `WakeOnLAN(ip, mac, { password, port })` where `ip` is an `IPAddress` instance, `mac` is a `MACAddress` instance, `password` is an optional `SecureONPassword` instance, and `port` is an optional integer parameter for which port the packet should be sent over (defaulted to the specification standard port, 9).

Once created, call the function `wake({ repeat, repeatDelay })` on the `WakeOnLAN` object to send the packet. You may optionally increase the `repeat` integer parameter and `repeatDelay` Duration parameter to repeatedly send the Wake-on-LAN packet before closing the socket connection.

```dart
String mac = 'AA:BB:CC:DD:EE:FF';
String ipv6 = '2001:0DB8:3333:4444:5555:6666:7777:8888';
String password = '00:11:22:33:44:55';

final macValidation = MACAddress.validate(mac);
final ipValidation = IPAddress.validate(ipv6, type: InternetAddressType.IPv6);
final passwordValidation = SecureONPassword.validate(password);

if(macValidation.state && ipValidation.state && passwordValidation.state) {
  MACAddress macAddress = MACAddress(mac);
  IPAddress ipAddress = IPAddress(ipv6, type: InternetAddressType.IPv6);
  SecureONPassword secureOnPassword = SecureONPassword(password);

  WakeOnLAN wakeOnLan = WakeOnLAN(ipAddress, macAddress, password: secureOnPassword);

  await wakeOnLan.wake(
    repeat: 5,
    repeatDelay: const Duration(milliseconds: 500),
  );
}
```

## Web Support

Wake-on-LAN functionality utilizes the [User Datagram Protocol (UDP)][link-wiki-udp] which is not available in the browser because of security constraints.

## Notes

Because Wake-on-LAN packets are sent over UDP, beyond the successful creation of a datagram socket and sending the data over the network there is no way to confirm that the machine has been awoken beyond pinging the machine after waking it (**This functionality is not implemented in this package**). This is because of the nature of UDP sockets which do not need to establish the connection for the data to be sent.

[link-broadcast-tool]: https://remotemonitoringsystems.ca/broadcast.php
[link-pubdev]: https://pub.dev/packages/wake_on_lan/
[link-wiki-udp]: https://en.wikipedia.org/wiki/User_Datagram_Protocol
[link-wiki-wol]: https://en.wikipedia.org/wiki/Wake-on-LAN
[image-license]: https://img.shields.io/github/license/JagandeepBrar/package-wake-on-lan?style=for-the-badge
[image-pubdev]: https://img.shields.io/pub/v/wake_on_lan.svg?style=for-the-badge
