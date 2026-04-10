import 'package:flutter/material.dart';

class AuthFormScaffold extends StatelessWidget {
  const AuthFormScaffold({
    super.key,
    required this.formKey,
    required this.child,
    this.appBar,
    this.padding = const EdgeInsets.all(24),
    this.autovalidateMode,
  });

  final GlobalKey<FormState> formKey;
  final Widget child;
  final PreferredSizeWidget? appBar;
  final EdgeInsetsGeometry padding;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Form(
            key: formKey,
            autovalidateMode: autovalidateMode,
            child: child,
          ),
        ),
      ),
    );
  }
}
