import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  AppThemeColors get semanticColors => AppTheme.semanticColorsOf(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get size => MediaQuery.of(this).size;
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

extension ContextThemeExtensions on BuildContext {
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;
}

extension ContextNavigationExtensions on BuildContext {
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(this, routeName, arguments: arguments);
  }

  Future<T?> pushReplacementNamed<T, TO>(String routeName, {TO? result, Object? arguments}) {
    return Navigator.pushReplacementNamed<T, TO>(this, routeName, arguments: arguments);
  }

  Future<T?> pushAndRemoveUntilNamed<T>(String routeName, bool Function(Route<dynamic>) predicate, {Object? arguments}) {
    return Navigator.pushAndRemoveUntil<T>(this, MaterialPageRoute(builder: (_) => routeName as Widget), predicate);
  }

  void pop<T>([T? result]) {
    Navigator.pop<T>(this, result);
  }
}
