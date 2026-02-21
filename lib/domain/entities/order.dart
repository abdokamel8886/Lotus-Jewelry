/// Order item - product snapshot at time of order
class OrderItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'price': price,
        'quantity': quantity,
        'imageUrl': imageUrl,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      quantity: json['quantity'] as int? ?? 1,
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
}

/// Order entity - stored under /users/{userId}/orders/{orderId}
class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final DateTime createdAt;
  final String status;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'items': items.map((e) => e.toJson()).toList(),
        'total': total,
        'createdAt': createdAt.toIso8601String(),
        'status': status,
      };

  factory Order.fromJson(Map<String, dynamic> json, String id) {
    final itemsRaw = json['items'] as List<dynamic>? ?? [];
    final items = itemsRaw
        .map((e) => OrderItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final createdAtStr = json['createdAt'] as String?;
    final createdAt = createdAtStr != null
        ? DateTime.tryParse(createdAtStr) ?? DateTime.now()
        : DateTime.now();
    return Order(
      id: id,
      userId: json['userId'] as String? ?? '',
      items: items,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      createdAt: createdAt,
      status: json['status'] as String? ?? 'pending',
    );
  }
}
