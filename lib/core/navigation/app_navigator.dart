import 'package:flutter/material.dart';
import '../../presentation/views/admin_view.dart';
import '../../presentation/views/auth_view.dart';
import '../../presentation/views/cart_view.dart';
import '../../presentation/views/checkout_view.dart';
import '../../presentation/views/main_shell_view.dart';
import '../../presentation/views/product_details_view.dart';

/// Custom navigator: no named routes so browser URL stays at base path.
/// Use [AppNavigator.of(context)] to push/pop without exposing paths.

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

abstract class AppNavigator {
  static NavigatorState? of(BuildContext? context) {
    return context != null ? Navigator.of(context) : appNavigatorKey.currentState;
  }

  static void goCart(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CartView()),
    );
  }

  static void goCheckout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CheckoutView()),
    );
  }

  static void goProductDetails(BuildContext context, String productId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailsView(productId: productId),
      ),
    );
  }

  static void goAuth(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthView()),
      (r) => false,
    );
  }

  static void goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShellView()),
      (r) => false,
    );
  }

  static void goAdmin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AdminView()),
      (r) => false,
    );
  }

  static void replaceWithHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShellView()),
    );
  }

  static void replaceWithAdmin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AdminView()),
    );
  }
}
