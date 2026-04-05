# E-Commerce Flutter App - Senior Level Architecture

A production-ready Flutter e-commerce application built with GetX state management and clean architecture principles.

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/                              # Core utilities and shared components
│   ├── bindings/                      # Global bindings
│   │   └── initial_binding.dart
│   ├── constants/                     # App-wide constants
│   │   └── app_colors.dart
│   ├── extensions/                    # Dart extensions
│   │   ├── context_extensions.dart
│   │   └── string_extensions.dart
│   ├── middlewares/                   # Route middlewares (auth, etc.)
│   ├── network/                       # Network layer
│   │   ├── api_client.dart           # Dio HTTP client wrapper
│   │   └── api_constants.dart        # API endpoints
│   ├── routes/                        # Navigation configuration
│   │   ├── app_routes.dart           # Route names
│   │   └── app_pages.dart            # Route pages configuration
│   ├── theme/                         # App theming
│   │   └── app_theme.dart
│   ├── utils/                         # Utility classes
│   │   ├── app_logger.dart
│   │   └── validators.dart
│   └── widgets/                       # Reusable widgets
│       ├── common/                    # Common widgets
│       │   ├── app_bar.dart
│       │   ├── empty_state.dart
│       │   └── loading_indicator.dart
│       ├── custom_buttons/            # Custom buttons
│       │   ├── primary_button.dart
│       │   └── secondary_button.dart
│       └── custom_inputs/             # Custom input fields
│           └── custom_text_field.dart
│
├── data/                              # Data layer
│   ├── models/                        # Data models
│   │   ├── cart_model.dart
│   │   ├── category_model.dart
│   │   ├── order_model.dart
│   │   ├── product_model.dart
│   │   ├── user_model.dart
│   │   └── models.dart               # Barrel export
│   ├── repositories/                  # Business logic repositories
│   │   ├── auth_repository.dart
│   │   ├── cart_repository.dart
│   │   ├── order_repository.dart
│   │   └── product_repository.dart
│   └── sources/                       # Data sources
│       └── local/
│           └── storage_service.dart  # Local storage wrapper
│
└── modules/                           # Feature modules
    ├── auth/                          # Authentication module
    │   ├── splash/
    │   │   ├── splash_binding.dart
    │   │   ├── splash_controller.dart
    │   │   └── splash_view.dart
    │   ├── login/
    │   │   ├── login_binding.dart
    │   │   ├── login_controller.dart
    │   │   └── login_view.dart
    │   ├── register/
    │   ├── onboarding/
    │   └── forgot_password/
    │
    ├── home/                          # Home module
    │   ├── home_binding.dart
    │   ├── home_controller.dart
    │   └── home_view.dart
    │
    ├── product/                       # Product module
    │   ├── details/
    │   └── reviews/
    │
    ├── cart/                          # Cart module
    ├── wishlist/                      # Wishlist module
    ├── orders/                        # Orders module
    │   ├── list/
    │   ├── details/
    │   └── checkout/
    │
    ├── profile/                       # Profile module
    │   ├── profile_view.dart
    │   ├── edit/
    │   └── addresses/
    │
    ├── search/                        # Search module
    ├── categories/                    # Categories module
    └── notifications/                 # Notifications module
```

## 🏗️ Architecture

This project follows a **feature-first** architecture with separation of concerns:

### Layers

1. **Presentation Layer** (`modules/`)
   - `View`: UI widgets (GetX pattern)
   - `Controller`: State management and business logic
   - `Binding`: Dependency injection

2. **Data Layer** (`data/`)
   - `Models`: Data structures
   - `Repositories`: Business logic and data coordination
   - `Sources`: Local (storage) and remote (API) data sources

3. **Core Layer** (`core/`)
   - Shared utilities, widgets, routes, theme, network client

### GetX Pattern

Each feature module follows the GetX pattern:
- **Binding**: Defines dependencies
- **Controller**: Handles state and logic
- **View**: UI rendering

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.11+
- Dart SDK 3.0+

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure API endpoint in `lib/core/network/api_constants.dart`:
   ```dart
   static const String baseUrl = 'https://your-api.com';
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `get` | State management & navigation |
| `get_storage` | Local storage |
| `dio` | HTTP client |
| `flutter_native_splash` | Native splash screen |

## 🔧 Configuration

### API Configuration

Edit `lib/core/network/api_constants.dart` to configure your backend API endpoints.

### Theme Configuration

Edit `lib/core/theme/app_theme.dart` to customize the app theme.

### Routes

Edit `lib/core/routes/app_routes.dart` to add or modify routes.

## 📝 Features

- ✅ Splash screen with app initialization
- ✅ Login/Register/Forgot Password flow
- ✅ Home screen with bottom navigation
- ✅ Product listing and details
- ✅ Shopping cart management
- ✅ Wishlist functionality
- ✅ Order management
- ✅ User profile and addresses
- ✅ Search functionality
- ✅ Categories browsing
- ✅ Notifications

## 🎨 UI Flow

```
Splash → Onboarding → Login → Home
                           ↓
        ┌──────────────────┼──────────────────┐
        ↓                  ↓                  ↓
    Products            Orders            Profile
        ↓                  ↓                  ↓
    Details            Checkout          Edit Profile
        ↓                  ↓                  ↓
    Reviews            Order Details     Addresses
        ↓
    Cart/Wishlist
```

## 📄 License

This project is for educational purposes.
