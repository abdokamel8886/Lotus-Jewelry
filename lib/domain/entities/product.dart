/// Domain entity - Product matching Firebase Realtime Database structure
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String category; // lowercase: rings, necklaces, bracelets
  final String? color;
  final String? material;
  final int discount; // percentage 0-100
  final bool inStock;
  final double? ratings;
  final String? size;
  final int stock;
  final List<String> tags;
  final num? weight;
  final String? length;
  final String? badge;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    this.color,
    this.material,
    this.discount = 0,
    this.inStock = true,
    this.ratings,
    this.size,
    this.stock = 0,
    this.tags = const [],
    this.weight,
    this.length,
    this.badge,
  });

  /// Primary image (first in list)
  String get imageUrl => images.isNotEmpty ? images.first : '';

  /// Price after discount
  double get finalPrice =>
      discount > 0 ? price * (1 - discount / 100) : price;

  /// Display category (capitalized)
  String get categoryDisplay =>
      category.isNotEmpty ? '${category[0].toUpperCase()}${category.substring(1)}' : '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'images': images,
        'imageUrl': imageUrl,
        'category': category,
        'color': color,
        'material': material,
        'discount': discount,
        'inStock': inStock,
        'ratings': ratings,
        'size': size,
        'stock': stock,
        'tags': tags,
        'weight': weight,
        'length': length,
      };

  factory Product.fromJson(Map<String, dynamic> json, [String? id]) {
    final imagesRaw = json['images'];
    List<String> imagesList = [];
    if (imagesRaw is List) {
      imagesList = imagesRaw.map((e) => e?.toString() ?? '').toList();
    } else if (json['imageUrl'] != null) {
      imagesList = [json['imageUrl'] as String];
    }

    final tagsRaw = json['tags'];
    List<String> tagsList = [];
    if (tagsRaw is List) {
      tagsList = tagsRaw.map((e) => e?.toString() ?? '').toList();
    }

    return Product(
      id: id ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      images: imagesList,
      category: (json['category'] as String? ?? '').toLowerCase(),
      color: json['color'] as String?,
      material: json['material'] as String?,
      discount: (json['discount'] as num?)?.toInt() ?? 0,
      inStock: json['inStock'] as bool? ?? true,
      ratings: (json['ratings'] as num?)?.toDouble(),
      size: json['size']?.toString(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      tags: tagsList,
      weight: json['weight'] as num?,
      length: json['length'] as String?,
      badge: json['badge'] as String?,
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    List<String>? images,
    String? category,
    String? color,
    String? material,
    int? discount,
    bool? inStock,
    double? ratings,
    String? size,
    int? stock,
    List<String>? tags,
    num? weight,
    String? length,
    String? badge,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
      category: category ?? this.category,
      color: color ?? this.color,
      material: material ?? this.material,
      discount: discount ?? this.discount,
      inStock: inStock ?? this.inStock,
      ratings: ratings ?? this.ratings,
      size: size ?? this.size,
      stock: stock ?? this.stock,
      tags: tags ?? this.tags,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      badge: badge ?? this.badge,
    );
  }
}
