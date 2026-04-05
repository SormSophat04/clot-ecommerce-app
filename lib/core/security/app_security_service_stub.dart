import 'security_state.dart';

class AppSecurityService {
  SecurityState _state = const SecurityState.secure();

  SecurityState get state => _state;

  Future<SecurityState> initialize({bool protectScreenCapture = true}) async {
    _state = const SecurityState.secure(
      warnings: <String>['Security checks are unavailable on this platform.'],
    );
    return _state;
  }
}
