import 'package:flutter/material.dart';

class PlatformButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final bool isFullWidth;

  const PlatformButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.height = 56,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final resolvedBg = backgroundColor ??
        theme.inputDecorationTheme.fillColor ??
        colorScheme.surfaceContainerHighest;
        
    final resolvedText = textColor ?? colorScheme.onSurface;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: resolvedBg,
          foregroundColor: resolvedText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Stack(
          children: [
            if (icon != null)
              Align(
                alignment: Alignment.centerLeft,
                child: icon!,
              ),
            Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: resolvedText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}