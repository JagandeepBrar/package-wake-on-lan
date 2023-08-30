import 'package:convert/convert.dart';

class MACAddress {
  final String address;
  final String delimiter;
  final List<int> bytes;

  MACAddress._internal({
    required this.address,
    required this.delimiter,
    required this.bytes,
  });

  /// Creates a new [MACAddress] instance with the given [address]. The MAC address
  /// is validated on construction and will throw an exception on an invalid address.
  ///
  /// **It is recommended to utilize the static function [validate]
  /// to first validate the format of the MAC address.**
  factory MACAddress(
    String address, {
    String delimiter = ':',
  }) {
    final validation = MACAddress.validate(address, delimiter: delimiter);
    if (!validation.state) {
      throw validation.error!;
    }

    List<String> split = address.split(delimiter);
    List<int> bytes = split.map((octet) => hex.decode(octet)[0]).toList();

    return MACAddress._internal(
      address: address,
      delimiter: delimiter,
      bytes: bytes,
    );
  }

  /// Validate that an IP [address] is correctly formatted by matching the MAC address
  /// against a regular expression. By default the [delimiter] between each
  /// hex octet is expected to be a colon (`:`).
  ///
  /// Returns a Dart 3 record type containing state and if poorly formatted, the error thrown.
  static ({bool state, Object? error}) validate(
    String? address, {
    String delimiter = ':',
  }) {
    if (address == null) {
      return (state: false, error: FormatException('Null MAC address'));
    }

    final delim = delimiter.split('').map((c) => '\\$c').toList().join();
    final regex = r'^([0-9A-Fa-f]{2}' + delim + r'){5}([0-9A-Fa-f]{2})$';
    RegExp exp = RegExp(regex);

    if (exp.hasMatch(address)) {
      return (state: true, error: null);
    }

    return (state: false, error: FormatException('Invalid MAC address'));
  }
}
