import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Where the session (tokens and profile) is kept between launches.
abstract class TokenStore {
  Future<String?> read();
  Future<void> write(String value);
  Future<void> clear();
}

/// Keychain on iOS, encrypted storage on Android. Tokens never go to plain
/// preferences or logs (NFR-SEC-05, NFR-SEC-09).
class SecureTokenStore implements TokenStore {
  new([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'belle.session';
  final FlutterSecureStorage _storage;

  @override
  Future<String?> read() => _storage.read(key: _key);

  @override
  Future<void> write(String value) => _storage.write(key: _key, value: value);

  @override
  Future<void> clear() => _storage.delete(key: _key);
}

/// For tests.
class MemoryTokenStore implements TokenStore {
  String? value;

  @override
  Future<String?> read() async => value;

  @override
  Future<void> write(String value) async => this.value = value;

  @override
  Future<void> clear() async => value = null;
}
