part of 'app_routes.dart';

abstract class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    // Main Layout Module
    GetPage(
      name: Routes.mainLayout,
      page: () => MainLayoutView(),
      binding: MainLayoutBinding(),
    ),

    // Auth Module
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const AuthToggle(initialIndex: AuthToggle.loginIndex),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const AuthToggle(initialIndex: AuthToggle.registerIndex),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.securityBlocked,
      page: () => const SecurityBlockedView(),
    ),

    // Home Module
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    // Product Module
    GetPage(
      name: Routes.product,
      page: () => const ProductView(),
    ),
    GetPage(
      name: Routes.productDetails,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: Routes.productReviews,
      page: () => const ProductReviewsView(),
      binding: ProductReviewsBinding(),
    ),

    // Cart Module
    GetPage(
      name: Routes.cart,
      page: () => const CartView(),
      binding: CartBinding(),
    ),

    // Wishlist Module
    GetPage(
      name: Routes.wishlist,
      page: () => const WishlistView(),
      binding: WishlistBinding(),
    ),

    // Orders Module
    GetPage(
      name: Routes.orders,
      page: () => const OrdersView(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: Routes.orderDetails,
      page: () => const OrderDetailsView(),
      binding: OrderDetailsBinding(),
    ),
    GetPage(
      name: Routes.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),

    // Profile Module
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.editProfile,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.addresses,
      page: () => const AddressesView(),
      binding: AddressesBinding(),
    ),
    GetPage(
      name: Routes.addAddress,
      page: () => const AddAddressView(),
      binding: AddAddressBinding(),
    ),
    GetPage(
      name: Routes.payment,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: Routes.addCard,
      page: () => const AddCardView(),
      binding: AddCardBinding(),
    ),

    // Search Module
    GetPage(
      name: Routes.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),

    // Categories Module
    GetPage(
      name: Routes.categories,
      page: () => const CategoriesView(),
      binding: CategoriesBinding(),
    ),

    // Notifications Module
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
  ];
}
