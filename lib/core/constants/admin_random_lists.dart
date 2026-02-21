/// Random lists for Admin "Add Product" dropdowns.
/// Edit this file to add or change options; choices are shown by category where relevant.

class AdminRandomLists {
  AdminRandomLists._();

  /// Categories for dropdown
  static const List<String> categories = [
    'rings',
    'necklaces',
    'bracelets',
    'earrings',
    'watches',
  ];

  /// Colors (used for all categories)
  static const List<String> colors = [
    'Yellow Gold',
    'White Gold',
    'Rose Gold',
    'Silver',
    'Black',
    'Two-Tone',
  ];

  /// Materials
  static const List<String> materials = [
    '18K Gold',
    '21K Gold',
    '24K Gold',
    '18K White Gold',
    '18K Rose Gold',
    'Sterling Silver',
    'Gold Plated',
    'Stainless Steel',
  ];

  /// Ring sizes (EU system)
  static const List<String> ringSizes = [
    '12','13','14','15','16','17','18','19','20','21','22'
  ];

  /// Necklace lengths
  static const List<String> necklaceLengths = [
    '38cm',
    '40cm',
    '45cm',
    '50cm',
    '55cm',
    '60cm',
  ];

  /// Bracelet sizes
  static const List<String> braceletSizes = [
    '16cm',
    '17cm',
    '18cm',
    '19cm',
    '20cm',
    'Adjustable',
  ];

  /// Watch sizes
  static const List<String> watchSizes = [
    '32mm',
    '36mm',
    '40mm',
    '42mm',
    'Adjustable Strap',
  ];

  /// Care instructions
  static const List<String> care = [
    'Clean with soft cloth, store in box',
    'Avoid contact with water and chemicals',
    'Remove before showering or swimming',
    'Store separately to avoid scratches',
    'Polish gently with jewelry cloth',
  ];

  /// Brands
  static const List<String> brands = [
    "L'azurde",
    "L'azurde Diamonds",
    "Miss L'",
    "Lotus Jewelry",
    "Royal Gold",
  ];

  /// Delivery options
  static const List<String> delivery = [
    'Same day delivery (Cairo only)',
    '1-3 business days',
    '3-5 business days',
    '5-7 business days',
    'Pre-order (10-14 days)',
  ];

  /// Occasions
  static const List<String> occasions = [
    'Wedding',
    'Engagement',
    'Anniversary',
    'Birthday',
    'Casual',
    'Party',
    'Formal',
  ];

  /// Gender
  static const List<String> genders = [
    'Women',
    'Men',
    'Unisex',
  ];

  /// Stock Status
  static const List<String> stockStatus = [
    'In Stock',
    'Low Stock',
    'Out of Stock',
    'Pre-order',
  ];

  /// Tags per category
  static const Map<String, List<String>> tagsByCategory = {
    'rings': [
      'gold',
      'ring',
      'wedding',
      'engagement',
      'band',
      'diamond',
      'luxury'
    ],
    'necklaces': [
      'gold',
      'necklace',
      'pendant',
      'chain',
      'luxury'
    ],
    'bracelets': [
      'gold',
      'bracelet',
      'bangle',
      'charm'
    ],
    'earrings': [
      'gold',
      'earrings',
      'stud',
      'hoop',
      'diamond'
    ],
    'watches': [
      'watch',
      'luxury',
      'gold',
      'classic'
    ],
  };

  /// Badges (optional)
  static const List<String> badges = [
    'Best Seller',
    'New Arrival',
    'Limited Edition',
    'Hot Deal',
    'Trending',
  ];

  /// Collections
  static const List<String> collections = [
    'Classic Collection',
    'Royal Collection',
    'Modern Collection',
    'Bridal Collection',
  ];

  /// Default tags for a category
  static List<String> tagsForCategory(String category) {
    return tagsByCategory[category] ?? ['gold'];
  }

  /// Size options based on category
  static List<String> sizeOptionsForCategory(String category) {
    switch (category) {
      case 'rings':
        return ringSizes;
      case 'necklaces':
        return necklaceLengths;
      case 'bracelets':
        return braceletSizes;
      case 'watches':
        return watchSizes;
      default:
        return [];
    }
  }
}