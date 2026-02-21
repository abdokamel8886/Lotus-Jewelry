/// Category entity - from Firebase /categories
class Category {
  final String id;
  final String name;
  final String imageUrl;

  const Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json, String id) {
    return Category(
      id: id,
      name: json['name'] as String? ?? id,
      imageUrl: json['image'] as String? ?? '',
    );
  }
}
