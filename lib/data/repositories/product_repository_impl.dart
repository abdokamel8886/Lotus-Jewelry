import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/dummy_products.dart';
import 'dart:async';

/// Implementation of ProductRepository using dummy data
/// Simulates async fetch with delay for loading placeholder demonstration
class ProductRepositoryImpl implements ProductRepository {
  // Simulated network delay
  static const Duration _delay = Duration(milliseconds: 800);

  @override
  Future<List<Product>> getProducts({String? category}) async {
    await Future.delayed(_delay);

    if (category == null || category == 'All') {
      return List.from(DummyProducts.all);
    }
    return DummyProducts.all
        .where((p) => p.category == category)
        .toList();
  }

  @override
  Future<Product?> getProductById(String id) async {
    await Future.delayed(_delay);
    try {
      return DummyProducts.all.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
