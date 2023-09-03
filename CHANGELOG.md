# 4.1.1+2

- chore: update documentation

# 4.1.1+1

- chore: update documentation

# 4.1.1

- tests: add tests for SecureONPassword

# 4.1.0

- feat: support passing and including a SecureON password when waking the machine
- chore: update documentation

# 4.0.0

- **BREAKING**: chore: minimum Dart constraint set to 3.0.0
- **BREAKING**: fix: `WakeOnLAN.fromString(...)` factory has been removed
- **BREAKING**: refactor: `IPv4Address` has been renamed to `IPAddress`
- **BREAKING**: refactor: static functions `validate(...)` on `IPAddress` and `MACAddress` now return a Dart 3 record with the validation state and validation error (on a validation failure)
- **BREAKING**: refactor: `typePredicate` has been renamed to `hostPredicate` for the factory constructor `IPAddress.fromHost(...)`
- feat: `IPAddress` now supports IPv6 addresses by setting the `type` property
- feat: allow setting the repeat delay alongside the repeat count when waking the machine
- chore: update documentation

# 3.2.0+1

- chore: update Dart environment bounds

# 3.2.0

- feat: allow repeatedly sending the packet in a single socket connection (Thanks to @AlexV525)
- feat: support constructing an `IPv4Address` instance from a host URL (Thanks to @AlexV525)

# 3.1.1+1

- chore: update metadata

# 3.1.1

- chore: update publishing workflow

# 3.1.0

- feat: Support custom delimiters for MAC addresses
- feat: Support instantiating a WakeOnLAN instance by strings using the `fromString` factory
- chore: updated metadata

# 3.0.0

- **BREAKING**: refactor: remove factory `IPv4Address.from(...)`, now instantiated with just `IPv4Address(...)`
- **BREAKING**: refactor: remove factory `MACAddress.from(...)`, now instantiated with just `MACAddress(...)`
- **BREAKING**: refactor: remove factory `WakeOnLAN.from(...)`, now instantiated with just `WakeOnLAN(...)`
- chore: updated documentation

# 2.0.3

- chore: updated dependencies

# 2.0.2

- chore: updated metadata

# 2.0.1

- fix: IPv4 address getter is no longer a nullable type

# 2.0.0

- feat: support null-safety/NNBD

# 1.1.2

- chore: updated dependencies

# 1.1.1

- refactor: improve code documentation

# 1.1.0

- **BREAKING**: refactor: `magicPacket` getter is now a function, `magicPacket()`
- tests: added test cases achieving 100% coverage

# 1.0.2

- fix: allow passing a null string to IPv4 and MAC validators
- tests: added tests

# 1.0.1

- chore: added example
- refactor: improve health analysis

# 1.0.0

- initial release
