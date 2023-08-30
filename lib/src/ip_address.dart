import 'dart:io';

class IPAddress {
  final String address;
  final InternetAddressType type;

  const IPAddress._internal({
    required this.address,
    required this.type,
  });

  /// Create a new [IPAddress] instance with the given [address]. The IP address
  /// is validated on construction and will throw an exception on an invalid address.
  ///
  /// **It is recommended to utilize the static function [validate]
  /// to first validate the format of the IP address.**
  ///
  /// The default address [type] is set to IPv4, but [type] can be set to [InternetAddressType.IPv6]
  /// with an IPv6 address ([InternetAddressType.unix] is not supported).
  factory IPAddress(
    String address, {
    InternetAddressType type = InternetAddressType.IPv4,
  }) {
    final validation = IPAddress.validate(address, type: type);
    if (!validation.state) {
      throw validation.error!;
    }

    return IPAddress._internal(
      address: address,
      type: type,
    );
  }

  /// Build an [IPAddress] instance from the [host]'s IP address of [type].
  ///
  /// By default the function will select and return the first address returned within the lookup.
  /// [hostPredicate] can be set to choose which host address is selected and returned.
  static Future<IPAddress> fromHost(
    String host, {
    InternetAddressType type = InternetAddressType.IPv4,
    InternetAddress Function(List<InternetAddress>)? hostPredicate,
  }) async {
    final result = await InternetAddress.lookup(
      host,
      type: type,
    );

    if (result.isEmpty) {
      throw StateError('No address was associate with the host ($host)');
    }

    final iAddr = hostPredicate?.call(result) ?? result.first;
    return IPAddress(iAddr.address, type: type);
  }

  /// Validate that an IP [address] is correctly formatted by attempting to
  /// parse the IP address utilizing the built-in URI parser.
  ///
  /// Returns a Dart 3 record type containing state and if poorly formatted, the error thrown.
  static ({bool state, Object? error}) validate(
    String? address, {
    InternetAddressType type = InternetAddressType.IPv4,
  }) {
    try {
      if (address == null) {
        return (state: false, error: FormatException('Null IP address'));
      }

      switch (type) {
        case InternetAddressType.IPv4:
          Uri.parseIPv4Address(address);
          return (state: true, error: null);
        case InternetAddressType.IPv6:
          Uri.parseIPv6Address(address);
          return (state: true, error: null);
        default:
          return (
            state: false,
            error: FormatException('Invalid InternetAddressType')
          );
      }
    } catch (error) {
      return (state: false, error: error);
    }
  }
}
