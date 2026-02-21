import 'package:flutter/foundation.dart';

import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../services/local_cart_storage.dart';

/// Cart repository - in-memory cart with local persistence (SharedPreferences)
class CartRepositoryImpl extends ChangeNotifier implements CartRepository {
  CartRepositoryImpl({LocalCartStorage? storage})
      : _storage = storage ?? LocalCartStorage() {
    _loadFromStorage();
  }

  final LocalCartStorage _storage;
  final List<CartItem> _items = [];

  Future<void> _loadFromStorage() async {
    final items = await _storage.loadCart();
    _items.clear();
    _items.addAll(items);
    notifyListeners();
  }

  Future<void> _persist() async {
    await _storage.saveCart(_items);
  }

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
    _persist();
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
      _persist();
    }
  }

  @override
  void removeFromCart(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
    _persist();
  }

  @override
  void clearCart() {
    _items.clear();
    notifyListeners();
    _persist();
  }

  @override
  double getTotalPrice() =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
}
