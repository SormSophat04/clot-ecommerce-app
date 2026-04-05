import 'package:flutter/material.dart';

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
