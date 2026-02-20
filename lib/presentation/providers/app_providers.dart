import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/services/firebase_auth_manager.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/product_repository.dart';

/// Firebase Auth Manager - use for sign in, sign up, sign out
final firebaseAuthManagerProvider = Provider<FirebaseAuthManager>((ref) {
  return FirebaseAuthManager();
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
