import 'dart:io';

extension BindAddressExtension on InternetAddressType {
  InternetAddress get bindAddress {
    if (this == InternetAddressType.IPv4) {
      return InternetAddress.anyIPv4;
    }

    if (this == InternetAddressType.IPv6) {
      return InternetAddress.anyIPv6;
    }

    throw UnsupportedError('$name does not have a supported bind address');
  }
}
