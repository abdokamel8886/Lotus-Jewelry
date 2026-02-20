import '../entities/product.dart';

/// Abstract repository - Product data operations
/// Domain layer defines the contract; Data layer implements it
abstract class ProductRepository {
  /// Fetches all products (or by category)
  Future<List<Product>> getProducts({String? category});

  /// Fetches a single product by ID
  Future<Product?> getProductById(String id);
}
