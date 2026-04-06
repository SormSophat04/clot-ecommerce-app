import 'package:flutter/material.dart';

class AuthFormScaffold extends StatelessWidget {
  const AuthFormScaffold({
    super.key,
    required this.formKey,
    required this.child,
    this.appBar,
    this.padding = const EdgeInsets.all(24),
  });

  final GlobalKey<FormState> formKey;
  final Widget child;
  final PreferredSizeWidget? appBar;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Form(key: formKey, child: child),
        ),
      ),
    );
  }
}
