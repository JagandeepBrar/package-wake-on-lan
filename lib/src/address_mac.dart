import 'package:convert/convert.dart';

/// [MACAddress] helps ensure that your MAC address has been formatted correctly.
///
/// The class has a static function, `validate(String address)` which allows easy validation that a MAC address string is correctly formatted.
class MACAddress {
  final String address;
  final String delimiter;
  final List<int> bytes;

  MACAddress._internal(this.address, this.delimiter, this.bytes);

  /// Creates [MACAddress] from the string [address].
  ///
  /// The address should first be validated using the static function [MACAddress.validate(address)].
  /// On an invalidly formatted [address] string, [FormatException] will be thrown.
  factory MACAddress(
    String address, {
    String delimiter = ':',
  }) {
    if (!MACAddress.validate(address, delimiter: delimiter)) {
      throw FormatException('Not a valid MAC address string');
    }

    List<String> split = address.split(delimiter);
    List<int> bytes = split.map((octet) => hex.decode(octet)[0]).toList();

    return MACAddress._internal(address, delimiter, bytes);
  }

  /// Validate that a MAC address in string [address] is correctly formatted.
  /// By default the delimiter between each hex octet is expected to be a colon (:).
  /// You can set a custom delimiter by setting the [delimiter] parameter.
  ///
  /// Returns [true] on a valid address, [false] on a poorly formatted [address].
  static bool validate(
    String? address, {
    String delimiter = ':',
  }) {
    if (address == null) return false;

    final delim = delimiter.split('').map((c) => '\\$c').toList().join();
    final regex = r'^([0-9A-Fa-f]{2}' + delim + r'){5}([0-9A-Fa-f]{2})$';
    RegExp exp = RegExp(regex);

    return exp.hasMatch(address);
  }
}
