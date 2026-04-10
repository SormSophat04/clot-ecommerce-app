import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../data/sources/local/storage_service.dart';

import 'login/login_view.dart';
import 'register/register_view.dart';

class AuthToggle extends StatefulWidget {
  static const int loginIndex = 0;
  static const int registerIndex = 1;

  final int initialIndex;

  const AuthToggle({super.key, this.initialIndex = loginIndex});

  @override
  State<AuthToggle> createState() => _AuthToggleState();
}

class _AuthToggleState extends State<AuthToggle> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex == AuthToggle.registerIndex
        ? AuthToggle.registerIndex
        : AuthToggle.loginIndex;
  }

  void _showLogin() {
    if (_currentIndex == AuthToggle.loginIndex) return;
    setState(() => _currentIndex = AuthToggle.loginIndex);
  }

  void _showRegister() {
    if (_currentIndex == AuthToggle.registerIndex) return;
    setState(() => _currentIndex = AuthToggle.registerIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex == AuthToggle.loginIndex) {
      return LoginView(
        key: const ValueKey('login_view'),
        onToggleToRegister: _showRegister,
      );
    }

    return RegisterView(
      key: const ValueKey('register_view'),
      onToggleToLogin: _showLogin,
    );
  }
}

class AuthRouteMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final storageService = Get.find<StorageService>();
    if (storageService.isLoggedIn) {
      return const RouteSettings(name: Routes.mainLayout);
    }
    return null;
  }
}
