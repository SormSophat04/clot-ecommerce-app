import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:safe_device/safe_device.dart';
import 'package:safe_device/safe_device_config.dart';

import '../utils/app_logger.dart';
import 'security_state.dart';

class AppSecurityService {
  SecurityState _state = const SecurityState.secure();

  SecurityState get state => _state;

  Future<SecurityState> initialize({bool protectScreenCapture = true}) async {
    final risks = <String>[];
    final warnings = <String>[];
    var screenshotProtectionEnabled = false;

    if (kIsWeb) {
      _state = const SecurityState.secure(
        warnings: <String>['Security checks are unavailable on web.'],
      );
      return _state;
    }

    if (protectScreenCapture && Platform.isAndroid) {
      screenshotProtectionEnabled = await _runCheck<bool>(
        checkName: 'android_secure_window',
        warnings: warnings,
        fallback: false,
        action: () async {
          return FlutterWindowManagerPlus.addFlags(
            FlutterWindowManagerPlus.FLAG_SECURE,
          );
        },
      );
    }

    if (!Platform.isAndroid && !Platform.isIOS) {
      _state = SecurityState.secure(
        screenshotProtectionEnabled: screenshotProtectionEnabled,
        warnings: const <String>[
          'Security checks only run on Android and iOS.',
        ],
      );
      return _state;
    }

    SafeDevice.init(const SafeDeviceConfig(mockLocationCheckEnabled: false));

    final safeDeviceJailBroken = await _runCheck<bool>(
      checkName: 'safe_device.isJailBroken',
      warnings: warnings,
      fallback: false,
      action: () async => SafeDevice.isJailBroken,
    );
    if (safeDeviceJailBroken) {
      risks.add('Root or jailbreak detected by safe_device.');
    }

    final safeDeviceRealDevice = await _runCheck<bool>(
      checkName: 'safe_device.isRealDevice',
      warnings: warnings,
      fallback: true,
      action: () async => SafeDevice.isRealDevice,
    );
    if (!safeDeviceRealDevice) {
      risks.add('Emulator or simulator detected by safe_device.');
    }

    final safeDeviceMockLocation = await _runCheck<bool>(
      checkName: 'safe_device.isMockLocation',
      warnings: warnings,
      fallback: false,
      action: () async => SafeDevice.isMockLocation,
    );
    if (safeDeviceMockLocation) {
      risks.add('Mock location detected by safe_device.');
    }

    if (Platform.isAndroid) {
      final onExternalStorage = await _runCheck<bool>(
        checkName: 'safe_device.isOnExternalStorage',
        warnings: warnings,
        fallback: false,
        action: () async => SafeDevice.isOnExternalStorage,
      );
      if (onExternalStorage) {
        risks.add('App is running from external storage (safe_device).');
      }

      final isUsbDebuggingEnabled = await _runCheck<bool>(
        checkName: 'safe_device.isUsbDebuggingEnabled',
        warnings: warnings,
        fallback: false,
        action: () async => SafeDevice.isUsbDebuggingEnabled,
      );
      if (isUsbDebuggingEnabled) {
        risks.add('USB debugging is enabled (safe_device).');
      }

      final isDevelopmentModeEnable = await _runCheck<bool>(
        checkName: 'safe_device.isDevelopmentModeEnable',
        warnings: warnings,
        fallback: false,
        action: () async => SafeDevice.isDevelopmentModeEnable,
      );
      if (isDevelopmentModeEnable) {
        risks.add('Developer options are enabled (safe_device).');
      }
    }

    final rootDetectionJailBroken = await _runCheck<bool>(
      checkName: 'jailbreak_root_detection.isJailBroken',
      warnings: warnings,
      fallback: false,
      action: () async => JailbreakRootDetection.instance.isJailBroken,
    );
    if (rootDetectionJailBroken) {
      risks.add('Root or jailbreak detected by jailbreak_root_detection.');
    }

    final rootDetectionRealDevice = await _runCheck<bool>(
      checkName: 'jailbreak_root_detection.isRealDevice',
      warnings: warnings,
      fallback: true,
      action: () async => JailbreakRootDetection.instance.isRealDevice,
    );
    if (!rootDetectionRealDevice) {
      risks.add('Emulator or simulator detected by jailbreak_root_detection.');
    }

    final rootDetectionDebugged = await _runCheck<bool>(
      checkName: 'jailbreak_root_detection.isDebugged',
      warnings: warnings,
      fallback: false,
      action: () async => JailbreakRootDetection.instance.isDebugged,
    );
    if (rootDetectionDebugged) {
      risks.add('Debugger detected by jailbreak_root_detection.');
    }

    if (Platform.isAndroid) {
      final rootDetectionDevMode = await _runCheck<bool>(
        checkName: 'jailbreak_root_detection.isDevMode',
        warnings: warnings,
        fallback: false,
        action: () async => JailbreakRootDetection.instance.isDevMode,
      );
      if (rootDetectionDevMode) {
        risks.add('Developer mode is enabled (jailbreak_root_detection).');
      }

      final rootDetectionExternalStorage = await _runCheck<bool>(
        checkName: 'jailbreak_root_detection.isOnExternalStorage',
        warnings: warnings,
        fallback: false,
        action: () async => JailbreakRootDetection.instance.isOnExternalStorage,
      );
      if (rootDetectionExternalStorage) {
        risks.add(
          'App is running from external storage (jailbreak_root_detection).',
        );
      }
    }

    final issues = await _runCheck<List<JailbreakIssue>>(
      checkName: 'jailbreak_root_detection.checkForIssues',
      warnings: warnings,
      fallback: const <JailbreakIssue>[],
      action: () async => JailbreakRootDetection.instance.checkForIssues,
    );
    if (issues.isNotEmpty) {
      final issueList = issues.map((issue) => issue.name).join(', ');
      risks.add('Detailed security issues reported: $issueList.');
    }

    final uniqueRisks = _toUniqueList(risks);
    final uniqueWarnings = _toUniqueList(warnings);

    _state = SecurityState(
      isTrustedDevice: uniqueRisks.isEmpty,
      screenshotProtectionEnabled: screenshotProtectionEnabled,
      risks: uniqueRisks,
      warnings: uniqueWarnings,
    );

    AppLogger.i(
      'Security initialized. trusted=${_state.isTrustedDevice}, '
      'risks=${_state.risks.length}, warnings=${_state.warnings.length}, '
      'secureWindow=${_state.screenshotProtectionEnabled}',
      tag: 'SECURITY',
    );

    return _state;
  }

  Future<T> _runCheck<T>({
    required String checkName,
    required List<String> warnings,
    required T fallback,
    required Future<T> Function() action,
  }) async {
    try {
      return await action();
    } catch (error) {
      warnings.add('$checkName failed: $error');
      AppLogger.w('Failed security check: $checkName', tag: 'SECURITY');
      return fallback;
    }
  }

  List<String> _toUniqueList(List<String> values) {
    return LinkedHashSet<String>.from(values).toList();
  }
}
