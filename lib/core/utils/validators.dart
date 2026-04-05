abstract class Validators {
  static String? Function(String?) get email => (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      };

  static String? Function(String?) get password => (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      };

  static String? Function(String?) get confirmPassword => (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        return null;
      };

  static String? Function(String?) get required => (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      };

  static String? Function(String?) get phone => (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required';
        }
        final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
        if (!phoneRegex.hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        return null;
      };

  static String? Function(String?) get name => (value) {
        if (value == null || value.isEmpty) {
          return 'Name is required';
        }
        if (value.length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      };

  static String? Function(String?) get address => (value) {
        if (value == null || value.isEmpty) {
          return 'Address is required';
        }
        if (value.length < 5) {
          return 'Please enter a valid address';
        }
        return null;
      };
}
