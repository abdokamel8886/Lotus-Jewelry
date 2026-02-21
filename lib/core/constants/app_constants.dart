/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'Lotus Jewelry';
  static const String logoAsset = 'assets/logo.png';

  // Routes
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeHome = '/home';
  static const String routeProductDetails = '/product-details';
  static const String routeCart = '/cart';
  static const String routeCheckout = '/checkout';
  static const String routeProfile = '/profile';
  static const String routeAdmin = '/admin';

  // Product categories
  static const String categoryAll = 'All';
  static const String categoryRings = 'Rings';
  static const String categoryNecklaces = 'Necklaces';
  static const String categoryBracelets = 'Bracelets';

  // Validation
  static const int minPasswordLength = 6;
  static const String emailRegex =
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // Admin login (show Admin page when signed in with this)
  static const String adminEmail = 'admin@admin.com';
  static const String adminPassword = '600600';

  /// Currency suffix for all prices in the app
  static const String currencySuffix = ' EGP';

  /// Format price for display (e.g. "1,250 EGP")
  static String formatPrice(double value, {int decimals = 0}) {
    final s = value.toStringAsFixed(decimals);
    return '$s$currencySuffix';
  }
}
