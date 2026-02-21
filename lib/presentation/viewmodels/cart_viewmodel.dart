import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart_item.dart';
import '../providers/app_providers.dart';

/// ViewModel for Cart - exposes cart state from repository
/// Listens to CartRepositoryImpl (ChangeNotifier) for reactive UI updates
final cartViewModelProvider = Provider<CartViewModel>((ref) {
  final cartRepo = ref.watch(cartRepositoryProvider);
  return CartViewModel(cartRepo);
});

/// Wrapper to expose cart as reactive state
class CartViewModel {
  final dynamic _cartRepository; // CartRepositoryImpl

  CartViewModel(this._cartRepository);

  List<CartItem> get items => _cartRepository.getCartItems();
  double get totalPrice => _cartRepository.getTotalPrice();
  int get itemCount => _cartRepository.itemCount;

  void addToCart(CartItem item) => _cartRepository.addToCart(item);
  void updateQuantity(String productId, int quantity, [String? selectedSize]) =>
      _cartRepository.updateQuantity(productId, quantity, selectedSize);
  void removeFromCart(String productId, [String? selectedSize]) =>
      _cartRepository.removeFromCart(productId, selectedSize);
  void clearCart() => _cartRepository.clearCart();
}
