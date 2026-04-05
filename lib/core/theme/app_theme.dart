import 'package:flutter/material.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color onInfo;
  final Color sale;
  final Color onSale;
  final Color priceOld;
  final Color shimmerBase;
  final Color shimmerHighlight;

  const AppThemeColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
    required this.sale,
    required this.onSale,
    required this.priceOld,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  static const AppThemeColors light = AppThemeColors(
    success: Color(0xFF1A7F37),
    onSuccess: Color(0xFFFFFFFF),
    warning: Color(0xFFB54708),
    onWarning: Color(0xFFFFFFFF),
    info: Color(0xFF1464C0),
    onInfo: Color(0xFFFFFFFF),
    sale: Color(0xFFBE123C),
    onSale: Color(0xFFFFFFFF),
    priceOld: Color(0xFF8B8FA3),
    shimmerBase: Color(0xFFE9E9EE),
    shimmerHighlight: Color(0xFFF7F7FA),
  );

  static const AppThemeColors dark = AppThemeColors(
    success: Color(0xFF58D68D),
    onSuccess: Color(0xFF093D1C),
    warning: Color(0xFFFFB547),
    onWarning: Color(0xFF4B2F00),
    info: Color(0xFF8CC8FF),
    onInfo: Color(0xFF0A355F),
    sale: Color(0xFFFF8AA8),
    onSale: Color(0xFF581227),
    priceOld: Color(0xFF9DA3BA),
    shimmerBase: Color(0xFF242433),
    shimmerHighlight: Color(0xFF323245),
  );

  @override
  AppThemeColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
    Color? sale,
    Color? onSale,
    Color? priceOld,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return AppThemeColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      sale: sale ?? this.sale,
      onSale: onSale ?? this.onSale,
      priceOld: priceOld ?? this.priceOld,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }
    return AppThemeColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      sale: Color.lerp(sale, other.sale, t)!,
      onSale: Color.lerp(onSale, other.onSale, t)!,
      priceOld: Color.lerp(priceOld, other.priceOld, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
    );
  }
}

abstract class AppTheme {
  static const Color _brandPrimary = Color(0xFF8E6CEF);

  static final ColorScheme _lightColorScheme = ColorScheme.fromSeed(
    seedColor: _brandPrimary,
    brightness: Brightness.light,
  ).copyWith(
    primary: const Color(0xFF8E6CEF),
    onPrimary: const Color(0xFFFFFFFF),
    primaryContainer: const Color(0xFFE7DEFF),
    onPrimaryContainer: const Color(0xFF2A1851),
    secondary: const Color(0xFF247A8F),
    onSecondary: const Color(0xFFFFFFFF),
    tertiary: const Color(0xFF8A5A2B),
    onTertiary: const Color(0xFFFFFFFF),
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF1A1A22),
    onSurfaceVariant: const Color(0xFF666779),
    error: const Color(0xFFB3261E),
    onError: const Color(0xFFFFFFFF),
    outline: const Color(0xFFD0D1DC),
    shadow: const Color(0x1A000000),
  );

  static final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: _brandPrimary,
    brightness: Brightness.dark,
  ).copyWith(
    primary: const Color(0xFFCDBAFF),
    onPrimary: const Color(0xFF35235F),
    primaryContainer: const Color(0xFF4B3681),
    onPrimaryContainer: const Color(0xFFE7DEFF),
    secondary: const Color(0xFF92D2E2),
    onSecondary: const Color(0xFF003642),
    tertiary: const Color(0xFFF9BC84),
    onTertiary: const Color(0xFF502A00),
    surface: const Color(0xFF101018),
    onSurface: const Color(0xFFE6E1EA),
    onSurfaceVariant: const Color(0xFFA5A4B5),
    error: const Color(0xFFF2B8B5),
    onError: const Color(0xFF601410),
    outline: const Color(0xFF8F90A1),
    shadow: const Color(0x66000000),
  );

  static ThemeData get lightTheme {
    return _buildTheme(_lightColorScheme, AppThemeColors.light);
  }

  static ThemeData get darkTheme {
    return _buildTheme(_darkColorScheme, AppThemeColors.dark);
  }

  static ThemeData _buildTheme(
    ColorScheme colorScheme,
    AppThemeColors semanticColors,
  ) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
    );

    final inputFillColor = colorScheme.brightness == Brightness.light
        ? const Color(0xFFF4F4F6)
        : const Color(0xFF1C1C28);

    final roundedInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      dividerColor: colorScheme.outline.withOpacity(0.45),
      splashColor: colorScheme.primary.withOpacity(0.08),
      highlightColor: colorScheme.primary.withOpacity(0.05),
      extensions: <ThemeExtension<dynamic>>[semanticColors],
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1.5,
        shadowColor: colorScheme.shadow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        border: roundedInputBorder,
        enabledBorder: roundedInputBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.primary.withOpacity(0.45),
          disabledForegroundColor: colorScheme.onPrimary.withOpacity(0.75),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: baseTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        backgroundColor: inputFillColor,
        selectedColor: colorScheme.primaryContainer,
        side: BorderSide.none,
        labelStyle: TextStyle(color: colorScheme.onSurface),
        secondaryLabelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
        checkmarkColor: colorScheme.onPrimaryContainer,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return TextStyle(color: colorScheme.onSurfaceVariant);
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
        actionTextColor: colorScheme.inversePrimary,
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: inputFillColor,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withOpacity(0.25),
        selectionHandleColor: colorScheme.primary,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
    );
  }

  static AppThemeColors semanticColorsOf(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<AppThemeColors>() ??
        (theme.brightness == Brightness.dark
            ? AppThemeColors.dark
            : AppThemeColors.light);
  }
}
