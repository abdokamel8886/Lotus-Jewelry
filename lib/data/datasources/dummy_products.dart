import '../../domain/entities/product.dart';
import '../../core/constants/app_constants.dart';

/// Dummy product data for UI development
/// Uses placeholder images from picsum.photos
class DummyProducts {
  DummyProducts._();

  static const List<Product> all = [
    Product(
      id: '1',
      name: 'Classic Gold Ring',
      description:
          'Elegant 18K gold ring with a timeless design. Perfect for daily wear or special occasions. Crafted with precision for lasting beauty.',
      price: 299.99,
      imageUrl: 'https://picsum.photos/seed/ring1/400/400',
      category: AppConstants.categoryRings,
    ),
    Product(
      id: '2',
      name: 'Diamond Studded Ring',
      description:
          'Stunning ring featuring brilliant diamonds set in premium gold. A symbol of luxury and sophistication.',
      price: 899.99,
      imageUrl: 'https://picsum.photos/seed/ring2/400/400',
      category: AppConstants.categoryRings,
    ),
    Product(
      id: '3',
      name: 'Vintage Gold Necklace',
      description:
          'Exquisite vintage-style necklace with intricate gold chain. A statement piece that complements any outfit.',
      price: 449.99,
      imageUrl: 'https://picsum.photos/seed/neck1/400/400',
      category: AppConstants.categoryNecklaces,
    ),
    Product(
      id: '4',
      name: 'Emerald Pendant Necklace',
      description:
          'Beautiful emerald pendant on a delicate gold chain. Nature-inspired elegance for the modern woman.',
      price: 599.99,
      imageUrl: 'https://picsum.photos/seed/neck2/400/400',
      category: AppConstants.categoryNecklaces,
    ),
    Product(
      id: '5',
      name: 'Bangle Bracelet Set',
      description:
          'Set of three thin gold bangles. Stack them or wear solo for a chic, versatile look.',
      price: 249.99,
      imageUrl: 'https://picsum.photos/seed/brace1/400/400',
      category: AppConstants.categoryBracelets,
    ),
    Product(
      id: '6',
      name: 'Tennis Bracelet',
      description:
          'Luxurious tennis bracelet with sparkling stones in a classic gold setting. Timeless elegance.',
      price: 1299.99,
      imageUrl: 'https://picsum.photos/seed/brace2/400/400',
      category: AppConstants.categoryBracelets,
    ),
    Product(
      id: '7',
      name: 'Rose Gold Band',
      description:
          'Soft rose gold band for a modern, romantic touch. Comfort fit design for all-day wear.',
      price: 179.99,
      imageUrl: 'https://picsum.photos/seed/ring3/400/400',
      category: AppConstants.categoryRings,
    ),
    Product(
      id: '8',
      name: 'Charm Bracelet',
      description:
          'Customizable charm bracelet in yellow gold. Add your personal touches to create a unique piece.',
      price: 349.99,
      imageUrl: 'https://picsum.photos/seed/brace3/400/400',
      category: AppConstants.categoryBracelets,
    ),
  ];
}
