import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/services/firebase_auth_manager.dart';
import '../../data/services/firebase_realtime_db_manager.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/product_repository.dart';

/// Firebase Auth Manager
final firebaseAuthManagerProvider = Provider<FirebaseAuthManager>((ref) {
  return FirebaseAuthManager();
});

/// Firebase Realtime Database Manager
final firebaseRealtimeDbManagerProvider =
    Provider<FirebaseRealtimeDbManager>((ref) {
  return FirebaseRealtimeDbManager();
});

/// Categories from Firebase (for home page)
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final db = ref.read(firebaseRealtimeDbManagerProvider);
  return db.getCategories();
});

/// Top products from Firebase /topProducts
final topProductsProvider = FutureProvider<List<Product>>((ref) async {
  final db = ref.read(firebaseRealtimeDbManagerProvider);
  return db.getTopProducts();
});

/// All products for Home tab grid
final homeProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.read(productRepositoryProvider);
  return repo.getProducts();
});

/// Riverpod providers - Dependency injection
/// Binds abstractions (interfaces) to implementations

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl();
});

/// Cart uses ChangeNotifierProvider for reactive updates when items change
final cartRepositoryProvider =
    ChangeNotifierProvider<CartRepositoryImpl>((ref) {
  return CartRepositoryImpl();
});

/// Type alias for CartRepository - use when you need the interface
final cartRepositoryInterfaceProvider = Provider<CartRepository>((ref) {
  return ref.watch(cartRepositoryProvider);
});
