import 'package:flutter/foundation.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

/// Implementation of CartRepository - in-memory cart
/// Uses ChangeNotifier for reactive updates (can be wrapped by Riverpod)
class CartRepositoryImpl extends ChangeNotifier implements CartRepository {
  final List<CartItem> _items = [];

  @override
  List<CartItem> getCartItems() => List.unmodifiable(_items);

  @override
  void addToCart(CartItem item) {
    final index = _items.indexWhere((i) => i.product.id == item.product.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + item.quantity,
      );
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  @override
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  @override
  void removeFromCart(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  @override
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  @override
  double getTotalPrice() =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  int get itemCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);
}
