import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  final Map<String, dynamic> _cache = <String, dynamic>{};

  // User keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // App keys
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _themeModeKey = 'theme_mode';
  static const String _languageCodeKey = 'language_code';

  Future<StorageService> init() async {
    final values = await _storage.readAll();
    for (final entry in values.entries) {
      _cache[entry.key] = _decode(entry.value);
    }
    return this;
  }

  // ========== Auth Methods ==========

  String? get token => _cache[_tokenKey] as String?;

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  Future<void> saveToken(String token) async {
    await _writeValue(_tokenKey, token);
  }

  Future<void> clearToken() async {
    await remove(_tokenKey);
  }

  // ========== User Data Methods ==========

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _writeValue(_userKey, userData);
  }

  Map<String, dynamic>? get userData {
    final data = _cache[_userKey];
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  Future<void> clearUserData() async {
    await remove(_userKey);
  }

  // ========== Onboarding Methods ==========

  bool get isOnboardingComplete => _cache[_onboardingCompleteKey] == true;

  Future<void> setOnboardingComplete() async {
    await _writeValue(_onboardingCompleteKey, true);
  }

  // ========== Theme Methods ==========

  String get themeMode {
    final mode = _cache[_themeModeKey];
    return mode is String ? mode : 'system';
  }

  Future<void> saveThemeMode(String mode) async {
    await _writeValue(_themeModeKey, mode);
  }

  // ========== Language Methods ==========

  String get languageCode {
    final code = _cache[_languageCodeKey];
    return code is String ? code : 'en';
  }

  Future<void> saveLanguageCode(String code) async {
    await _writeValue(_languageCodeKey, code);
  }

  // ========== Generic Methods ==========

  Future<void> write(String key, dynamic value) async {
    await _writeValue(key, value);
  }

  T? read<T>(String key) {
    final value = _cache[key];
    if (value is T) {
      return value;
    }
    return null;
  }

  Future<void> remove(String key) async {
    _cache.remove(key);
    await _storage.delete(key: key);
  }

  Future<void> clear() async {
    _cache.clear();
    await _storage.deleteAll();
  }

  Future<void> clearAuth() async {
    await clearToken();
    await clearUserData();
  }

  Future<void> _writeValue(String key, dynamic value) async {
    _cache[key] = value;
    await _storage.write(key: key, value: _encode(value));
  }

  String _encode(dynamic value) {
    try {
      return jsonEncode(value);
    } catch (_) {
      return value?.toString() ?? '';
    }
  }

  dynamic _decode(String raw) {
    try {
      return jsonDecode(raw);
    } catch (_) {
      // Backward compatibility in case old values were stored as plain strings.
      return raw;
    }
  }
}
