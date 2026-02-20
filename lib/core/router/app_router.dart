import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../presentation/views/cart_view.dart';
import '../../presentation/views/home_view.dart';
import '../../presentation/views/login_view.dart';
import '../../presentation/views/product_details_view.dart';
import '../../presentation/views/register_view.dart';

/// App routing configuration
/// Centralizes all route definitions for clean navigation
class AppRouter {
  AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.routeLogin:
        return MaterialPageRoute(
          builder: (_) => const LoginView(),
          settings: settings,
        );
      case AppConstants.routeRegister:
        return MaterialPageRoute(
          builder: (_) => const RegisterView(),
          settings: settings,
        );
      case AppConstants.routeHome:
        return MaterialPageRoute(
          builder: (_) => const HomeView(),
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
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginView(),
          settings: settings,
        );
    }
  }
}
