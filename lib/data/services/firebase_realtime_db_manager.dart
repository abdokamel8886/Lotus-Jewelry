import 'package:firebase_database/firebase_database.dart';

import '../../core/constants/database_constants.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/product.dart';

/// Firebase Realtime Database Manager - products and categories
class FirebaseRealtimeDbManager {
  FirebaseRealtimeDbManager({DatabaseReference? ref})
      : _ref = ref ?? FirebaseDatabase.instance.ref();

  final DatabaseReference _ref;

  /// Fetches categories from /categories
  Future<List<Category>> getCategories() async {
    final snapshot = await _ref.child(DatabaseConstants.categoriesPath).get();
    if (!snapshot.exists || snapshot.value == null) return [];

    final map = snapshot.value as Map<Object?, Object?>;
    final list = <Category>[];

    for (final entry in map.entries) {
      final id = entry.key as String;
      final data = entry.value as Map<Object?, Object?>?;
      if (data == null) continue;

      final json = data.map((k, v) => MapEntry(k.toString(), v));
      list.add(Category.fromJson(json, id));
    }

    return list;
  }

  /// Fetches top products from /topProducts
  Future<List<Product>> getTopProducts() async {
    final snapshot =
        await _ref.child(DatabaseConstants.topProductsPath).get();
    if (!snapshot.exists || snapshot.value == null) return [];

    final map = snapshot.value as Map<Object?, Object?>;
    final list = <Product>[];

    for (final entry in map.entries) {
      final data = entry.value as Map<Object?, Object?>?;
      if (data == null) continue;

      final json = data.map((k, v) => MapEntry(k.toString(), v));
      final id = json['id'] as String? ?? entry.key.toString();
      list.add(Product.fromJson(json, id));
    }

    return list;
  }

  /// Fetches products. category: null = all, or "rings"|"necklaces"|"bracelets"
  Future<List<Product>> getProducts({String? category}) async {
    final snapshot = await _ref.child(DatabaseConstants.productsPath).get();
    if (!snapshot.exists || snapshot.value == null) return [];

    final map = snapshot.value as Map<Object?, Object?>;
    final products = <Product>[];

    for (final entry in map.entries) {
      final id = entry.key as String;
      final data = entry.value as Map<Object?, Object?>?;
      if (data == null) continue;

      final json = data.map((k, v) => MapEntry(k.toString(), v));
      final product = Product.fromJson(json, id);

      final filterCategory = category?.toLowerCase();
      if (filterCategory == null ||
          filterCategory.isEmpty ||
          filterCategory == 'all' ||
          product.category == filterCategory) {
        products.add(product);
      }
    }

    return products;
  }

  /// Adds a new product to /products. Returns the new product key.
  Future<String> addProduct(Map<String, dynamic> data) async {
    final ref = _ref.child(DatabaseConstants.productsPath).push();
    await ref.set(data);
    return ref.key!;
  }

  /// Saves order under /users/{userId}/orders/{orderId}
  Future<void> saveOrder(Order order) async {
    final path = DatabaseConstants.userOrdersPath(order.userId);
    await _ref.child(path).child(order.id).set(order.toJson());
  }

  /// Fetches orders for a user
  Future<List<Order>> getOrders(String userId) async {
    final snapshot =
        await _ref.child(DatabaseConstants.userOrdersPath(userId)).get();
    if (!snapshot.exists || snapshot.value == null) return [];

    final map = snapshot.value as Map<Object?, Object?>;
    final list = <Order>[];

    for (final entry in map.entries) {
      final id = entry.key as String;
      final data = entry.value as Map<Object?, Object?>?;
      if (data == null) continue;

      final json = data.map((k, v) => MapEntry(k.toString(), v));
      list.add(Order.fromJson(json, id));
    }

    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<Product?> getProductById(String id) async {
    final snapshot =
        await _ref.child(DatabaseConstants.productsPath).child(id).get();
    if (!snapshot.exists || snapshot.value == null) return null;

    final data = snapshot.value as Map<Object?, Object?>;
    final json = data.map((k, v) => MapEntry(k.toString(), v));
    return Product.fromJson(json, id);
  }
}
