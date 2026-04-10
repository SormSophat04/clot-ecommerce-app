import 'package:clot_ecommerce_app/modules/home/home_binding.dart';
import 'package:clot_ecommerce_app/modules/main_layout/main_layout_binding.dart';
import 'package:clot_ecommerce_app/modules/main_layout/main_layout_view.dart';
import 'package:clot_ecommerce_app/modules/notifications/notifications_binding.dart';
import 'package:clot_ecommerce_app/modules/product/product_binding.dart';
import 'package:clot_ecommerce_app/modules/product/details/product_details_binding.dart';
import 'package:get/get.dart';

import '../../modules/auth/splash/splash_view.dart';
import '../../modules/auth/splash/splash_binding.dart';
import '../../modules/auth/onboarding/onboarding_view.dart';
import '../../modules/auth/auth_toggle.dart';
import '../../modules/auth/auth_controller/auth_binding.dart';
import '../../modules/auth/forgot_password/forgot_password_view.dart';
import '../../modules/security/security_blocked_view.dart';
import '../../modules/home/home_view.dart';
import '../../modules/product/product_view.dart';
import '../../modules/product/details/product_details_view.dart';
import '../../modules/product/reviews/product_reviews_view.dart';
import '../../modules/cart/cart_view.dart';
import '../../modules/cart/cart_binding.dart';
import '../../modules/wishlist/wishlist_view.dart';
import '../../modules/orders/list/orders_view.dart';
import '../../modules/orders/details/order_details_view.dart';
import '../../modules/orders/checkout/checkout_view.dart';
import '../../modules/profile/profile_view.dart';
import '../../modules/profile/edit/edit_profile_view.dart';
import '../../modules/profile/addresses/addresses_view.dart';
import '../../modules/profile/addresses/add_address_view.dart';
import '../../modules/profile/payment/payment_view.dart';
import '../../modules/profile/payment/add_card_view.dart';
import '../../modules/search/search_view.dart';
import '../../modules/categories/categories_binding.dart';
import '../../modules/categories/categories_view.dart';
import '../../modules/notifications/notifications_view.dart';

part 'app_pages.dart';

abstract class Routes {
  // Auth Module
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const securityBlocked = '/security-blocked';

  // Main Layout Module
  static const mainLayout = '/main-layout';

  // Home Module
  static const home = '/home';

  // Product Module
  static const product = '/product';
  static const productDetails = '/product-details';
  static const productReviews = '/product-reviews';

  // Cart Module
  static const cart = '/cart';

  // Wishlist Module
  static const wishlist = '/wishlist';

  // Orders Module
  static const orders = '/orders';
  static const orderDetails = '/order-details';
  static const checkout = '/checkout';

  // Profile Module
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const addresses = '/addresses';
  static const addAddress = '/add-address';
  static const payment = '/payment';
  static const addCard = '/add-card';

  // Search Module
  static const search = '/search';

  // Categories Module
  static const categories = '/categories';

  // Notifications Module
  static const notifications = '/notifications';
}
