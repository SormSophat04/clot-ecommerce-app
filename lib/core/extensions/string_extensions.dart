extension StringExtensions on String {
  /// Capitalize first letter of string
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Check if string is a valid phone number
  bool get isValidPhone {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(this);
  }

  /// Remove all whitespace from string
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Truncate string to specified length
  String truncate(int length) {
    if (length <= 0) return '';
    if (this.length <= length) return this;
    return '${substring(0, length)}...';
  }

  /// Format price string (e.g., "100.00" -> "$100.00")
  String formatPrice({String symbol = '\$', int decimalDigits = 2}) {
    final number = double.tryParse(this) ?? 0.0;
    return '$symbol${number.toStringAsFixed(decimalDigits)}';
  }
}

extension StringNullableExtensions on String? {
  /// Check if nullable string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if nullable string is not null and not empty
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;
}
