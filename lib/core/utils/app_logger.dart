import 'package:flutter/foundation.dart';

abstract class AppLogger {
  static const String _prefix = '📱 [E-COMMERCE]';

  static void d(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('$_prefix ${tag != null ? '[$tag]' : ''} D: $message');
    }
  }

  static void i(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('$_prefix ${tag != null ? '[$tag]' : ''} I: $message');
    }
  }

  static void w(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('$_prefix ${tag != null ? '[$tag]' : ''} W: $message');
    }
  }

  static void e(String message, {String? tag, Object? error}) {
    if (kDebugMode) {
      debugPrint('$_prefix ${tag != null ? '[$tag]' : ''} E: $message${error != null ? '\nError: $error' : ''}');
    }
  }

  static void json(String jsonString, {String? tag}) {
    if (kDebugMode) {
      debugPrint('$_prefix ${tag != null ? '[$tag]' : ''} JSON: $jsonString');
    }
  }
}
