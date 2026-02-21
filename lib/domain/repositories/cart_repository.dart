import '../entities/cart_item.dart';

/// Abstract repository - Cart operations
abstract class CartRepository {
  /// Gets all cart items
  List<CartItem> getCartItems();

  /// Adds product to cart
  void addToCart(CartItem item);

  /// Updates quantity of item in cart (match by productId + optional selectedSize)
  void updateQuantity(String productId, int quantity, [String? selectedSize]);

  /// Removes item from cart (match by productId + optional selectedSize)
  void removeFromCart(String productId, [String? selectedSize]);

  /// Clears the entire cart
  void clearCart();

  /// Gets total price of cart
  double getTotalPrice();

  /// Stream or notifier for cart changes (handled by state management)
  int get itemCount;
}
