import 'package:flutter/material.dart';

class PlatformButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final bool isFullWidth;

  const PlatformButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.backgroundColor = const Color(0xFFF4F4F4),
    this.textColor = Colors.black,
    this.height = 56,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
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
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}