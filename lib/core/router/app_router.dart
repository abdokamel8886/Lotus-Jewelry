import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../presentation/views/cart_view.dart';
import '../../presentation/views/checkout_view.dart';
import '../../presentation/views/main_shell_view.dart';
import '../../presentation/views/auth_view.dart';
import '../../presentation/views/login_view.dart';
import '../../presentation/views/product_details_view.dart';
import '../../presentation/views/admin_view.dart';
import '../../presentation/views/register_view.dart';

/// App routing configuration
/// Centralizes all route definitions for clean navigation
class AppRouter {
  AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.routeLogin:
        return MaterialPageRoute(
          builder: (_) => const AuthView(initialIndex: 0),
          settings: settings,
        );
      case AppConstants.routeRegister:
        return MaterialPageRoute(
          builder: (_) => const AuthView(initialIndex: 1),
          settings: settings,
        );
      case AppConstants.routeHome:
        return MaterialPageRoute(
          builder: (_) => const MainShellView(),
          settings: settings,
        );
      case AppConstants.routeProductDetails:
        final productId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => ProductDetailsView(productId: productId),
          settings: settings,
        );
      case AppConstants.routeCart:
        return MaterialPageRoute(
          builder: (_) => const CartView(),
          settings: settings,
        );
      case AppConstants.routeCheckout:
        return MaterialPageRoute(
          builder: (_) => const CheckoutView(),
          settings: settings,
        );
      case AppConstants.routeAdmin:
        return MaterialPageRoute(
          builder: (_) => const AdminView(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const AuthView(),
          settings: settings,
        );
    }
  }
}
