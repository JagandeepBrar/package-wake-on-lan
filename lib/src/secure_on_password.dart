import 'package:convert/convert.dart';

class SecureONPassword {
  final String password;
  final String delimiter;
  final List<int> bytes;

  SecureONPassword._internal({
    required this.password,
    required this.delimiter,
    required this.bytes,
  });

  /// Creates a new [SecureONPassword] instance with the given [password]. The SecureON password
  /// is validated on construction and will throw an exception on an invalid password.
  ///
  /// **It is recommended to utilize the static function [validate]
  /// to first validate the format of the SecureON password.**
  factory SecureONPassword(
    String password, {
    String delimiter = ':',
  }) {
    final validation = SecureONPassword.validate(
      password,
      delimiter: delimiter,
    );
    if (!validation.state) {
      throw validation.error!;
    }

    List<String> split = password.split(delimiter);
    List<int> bytes = split.map((octet) => hex.decode(octet)[0]).toList();

    return SecureONPassword._internal(
      password: password,
      delimiter: delimiter,
      bytes: bytes,
    );
  }

  /// Validate that a [password] is correctly formatted by matching the password
  /// against a regular expression. By default the [delimiter] between each
  /// hex octet is expected to be a colon (`:`).
  ///
  /// Returns a Dart 3 record type containing state and if poorly formatted, the error thrown.
  static ({bool state, Object? error}) validate(
    String? password, {
    String delimiter = ':',
  }) {
    if (password == null) {
      return (state: false, error: FormatException('Null SecureON password'));
    }

    final delim = delimiter.split('').map((c) => '\\$c').toList().join();
    final regex = r'^([0-9A-Fa-f]{2}' + delim + r'){5}([0-9A-Fa-f]{2})$';
    RegExp exp = RegExp(regex);

    if (exp.hasMatch(password)) {
      return (state: true, error: null);
    }

    return (state: false, error: FormatException('Invalid SecureON password'));
  }
}
