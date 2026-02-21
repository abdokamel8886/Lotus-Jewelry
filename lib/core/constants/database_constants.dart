/// Firebase Realtime Database paths
class DatabaseConstants {
  DatabaseConstants._();

  static const String productsPath = 'products';
  static const String categoriesPath = 'categories';
  static const String topProductsPath = 'topProducts';

  /// Path: users/{userId}/orders/{orderId}
  static String userOrdersPath(String userId) => 'users/$userId/orders';
}
