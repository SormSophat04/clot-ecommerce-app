abstract class ApiConstants {
  // Base URL - Change this to your API endpoint
  static const String baseUrl = 'https://api.your-ecommerce.com';
  static const String apiVersion = '/api/v1';

  // Endpoints
  static const String login = '$apiVersion/auth/login';
  static const String register = '$apiVersion/auth/register';
  static const String logout = '$apiVersion/auth/logout';
  static const String refreshToken = '$apiVersion/auth/refresh';
  static const String forgotPassword = '$apiVersion/auth/forgot-password';
  static const String resetPassword = '$apiVersion/auth/reset-password';

  // User
  static const String userProfile = '$apiVersion/user/profile';
  static const String updateProfile = '$apiVersion/user/update';

  // Products
  static const String products = '$apiVersion/products';
  static const String productDetails = '$apiVersion/products';
  static const String productReviews = '$apiVersion/products/reviews';
  static const String categories = '$apiVersion/categories';
  static const String search = '$apiVersion/products/search';

  // Cart
  static const String cart = '$apiVersion/cart';
  static const String addToCart = '$apiVersion/cart/add';
  static const String removeFromCart = '$apiVersion/cart/remove';
  static const String updateCart = '$apiVersion/cart/update';

  // Wishlist
  static const String wishlist = '$apiVersion/wishlist';
  static const String addToWishlist = '$apiVersion/wishlist/add';
  static const String removeFromWishlist = '$apiVersion/wishlist/remove';

  // Orders
  static const String orders = '$apiVersion/orders';
  static const String orderDetails = '$apiVersion/orders';
  static const String checkout = '$apiVersion/orders/checkout';

  // Addresses
  static const String addresses = '$apiVersion/addresses';
  static const String addAddress = '$apiVersion/addresses/add';
  static const String updateAddress = '$apiVersion/addresses/update';
  static const String deleteAddress = '$apiVersion/addresses/delete';

  // Notifications
  static const String notifications = '$apiVersion/notifications';

  // Timeout
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}
