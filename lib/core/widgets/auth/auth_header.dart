import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.topSpacing,
  });

  final String title;
  final String? subtitle;
  final double? topSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (topSpacing != null) SizedBox(height: topSpacing),
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 16),
          Text(subtitle!, style: const TextStyle(fontSize: 14)),
        ],
      ],
    );
  }
}
