/// [IPv4Address] helps ensure that your IPv4 address has been formatted correctly.
///
/// The class has a static function, `validate(String address)` which allows easy validation that an IPv4 address string is correctly formatted.
class IPv4Address {
  final String address;

  IPv4Address._internal(this.address);

  /// Creates [IPv4Address] from string [address].
  ///
  /// The address should first be validated using the static function [IPv4Address.validate(address)].
  /// On an invalidly formatted [address] string, [FormatException] will be thrown.
  ///
  /// When using for Wake on LAN functionality, please ensure this address is the broadcast IPv4 address of your network.
  /// This typically is the IPv4 address of your machine with the last block set to 255.
  /// _This can differ depending on the subnet mask used for the network_.
  factory IPv4Address(String address) {
    if (!IPv4Address.validate(address)) {
      throw FormatException('Not a valid IPv4 address string');
    }

    return IPv4Address._internal(address);
  }

  /// Validate that an IPv4 address in string [address] is correctly formatted.
  ///
  /// Returns [true] on a valid address, [false] on a poorly formatted [address].
  static bool validate(String? address) {
    if (address == null) return false;

    final regex = r"\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b";
    RegExp exp = RegExp(regex);

    return exp.hasMatch(address);
  }
}
