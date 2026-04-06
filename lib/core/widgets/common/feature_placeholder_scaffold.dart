import 'package:flutter/material.dart';

import 'empty_state.dart';

class FeaturePlaceholderScaffold extends StatelessWidget {
  const FeaturePlaceholderScaffold({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.actions,
    this.showAppBar = true,
  });

  final String title;
  final String message;
  final IconData? icon;
  final List<Widget>? actions;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar(title: Text(title), actions: actions) : null,
      body: EmptyState(
        title: title,
        subtitle: message,
        icon: icon ?? Icons.construction_rounded,
      ),
    );
  }
}
