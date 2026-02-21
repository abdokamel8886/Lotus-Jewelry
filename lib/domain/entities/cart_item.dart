import '../entities/product.dart';

/// Domain entity - Cart item (product + quantity + optional selected size)
class CartItem {
  final Product product;
  final int quantity;
  final String? selectedSize;

  const CartItem({
    required this.product,
    required this.quantity,
    this.selectedSize,
  });

  double get totalPrice => product.finalPrice * quantity;

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'selectedSize': selectedSize,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(
        Map<String, dynamic>.from(json['product'] as Map? ?? {}),
      ),
      quantity: json['quantity'] as int? ?? 1,
      selectedSize: json['selectedSize'] as String?,
    );
  }

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? selectedSize,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }
}
