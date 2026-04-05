class SecurityState {
  final bool isTrustedDevice;
  final bool screenshotProtectionEnabled;
  final List<String> risks;
  final List<String> warnings;

  const SecurityState({
    required this.isTrustedDevice,
    required this.screenshotProtectionEnabled,
    this.risks = const <String>[],
    this.warnings = const <String>[],
  });

  const SecurityState.secure({
    this.screenshotProtectionEnabled = false,
    this.warnings = const <String>[],
  }) : isTrustedDevice = true,
       risks = const <String>[];
}
