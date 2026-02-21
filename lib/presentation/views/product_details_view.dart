import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import '../providers/app_providers.dart';
import '../viewmodels/product_details_viewmodel.dart';

/// Product details - L'azurde-style layout: gallery, title, price, CTAs, trust badges, Designer's Notes, Design Details
class ProductDetailsView extends ConsumerWidget {
  final String productId;

  const ProductDetailsView({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productDetailsViewModelProvider(productId));
    final cartRepo = ref.watch(cartRepositoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Product'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.charcoal,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => AppNavigator.goCart(context),
          ),
        ],
      ),
      body: productState.when(
        data: (product) {
          if (product == null) {
            return const Center(child: Text('Product not found'));
          }
          final similarState = ref.watch(similarProductsProvider((
            category: product.category,
            excludeId: product.id,
          )));
          return _ProductDetailsContent(
            product: product,
            similarProductsState: similarState,
            onAddToCart: (selectedSize) {
              if (!product.inStock) return;
              cartRepo.addToCart(CartItem(
                product: product,
                quantity: 1,
                selectedSize: selectedSize,
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} added to cart'),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'View Cart',
                    onPressed: () => AppNavigator.goCart(context),
                  ),
                ),
              );
            },
            onBuyNow: (selectedSize) {
              if (!product.inStock) return;
              cartRepo.addToCart(CartItem(
                product: product,
                quantity: 1,
                selectedSize: selectedSize,
              ));
              AppNavigator.goCheckout(context);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey.shade500),
              const SizedBox(height: 16),
              Text(
                'Could not load product',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductDetailsContent extends StatefulWidget {
  final Product product;
  final AsyncValue<List<Product>> similarProductsState;
  final void Function(String? selectedSize) onAddToCart;
  final void Function(String? selectedSize) onBuyNow;

  const _ProductDetailsContent({
    required this.product,
    required this.similarProductsState,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  State<_ProductDetailsContent> createState() => _ProductDetailsContentState();
}

class _ProductDetailsContentState extends State<_ProductDetailsContent> {
  int _imageIndex = 0;
  String? _selectedSize;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _canAddToCart(Product product) {
    if (!product.inStock) return false;
    if (product.hasSizes && _selectedSize == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = product.images.isNotEmpty ? product.images : [product.imageUrl];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ImageGallery(
            controller: _pageController,
            images: images,
            currentIndex: _imageIndex,
            onPageChanged: (i) => setState(() => _imageIndex = i),
            discount: product.discount,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  product.categoryDisplay,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.charcoal,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Write a Review',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '\$${product.finalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.charcoal,
                  ),
                ),
                if (product.discount > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Was \$${product.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade500,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
                if (product.hasSizes) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Size',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: (product.sizes ?? []).map((s) {
                      final isSelected = _selectedSize == s;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSize = s),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.gold : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? AppTheme.gold : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            s,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : AppTheme.charcoal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (product.hasSizes && _selectedSize == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Please select a size',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _canAddToCart(product) ? () => widget.onAddToCart(_selectedSize) : null,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppTheme.charcoal),
                            foregroundColor: AppTheme.charcoal,
                          ),
                          child: const Text('Add to Cart'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _canAddToCart(product) ? () => widget.onBuyNow(_selectedSize) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.charcoal,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Buy Now'),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!product.inStock)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Out of stock',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                _TrustBadges(),
                const SizedBox(height: 28),
                _SectionTitle(title: "Designer's Notes"),
                const SizedBox(height: 10),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 28),
                _SectionTitle(title: 'Design Details'),
                const SizedBox(height: 12),
                _DesignDetailsCard(product: product),
                const SizedBox(height: 32),
                _SectionTitle(title: 'You May Also Like'),
                const SizedBox(height: 12),
                _YouMayAlsoLike(similarProductsState: widget.similarProductsState),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _YouMayAlsoLike extends StatelessWidget {
  final AsyncValue<List<Product>> similarProductsState;

  const _YouMayAlsoLike({required this.similarProductsState});

  @override
  Widget build(BuildContext context) {
    return similarProductsState.when(
      data: (products) {
        if (products.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final p = products[index];
              return _SimilarProductCard(
                product: p,
                onTap: () => AppNavigator.goProductDetails(context, p.id),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _SimilarProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _SimilarProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(Icons.image, color: Colors.grey.shade400),
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: Colors.grey.shade100,
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                    if (product.discount > 0)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '-${product.discount}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppTheme.charcoal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product.finalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppTheme.gold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final PageController controller;
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final int discount;

  const _ImageGallery({
    required this.controller,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
    this.discount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Column(
        children: [
          SizedBox(
            height: 340,
            child: Stack(
              children: [
                PageView.builder(
                  controller: controller,
                  itemCount: images.length,
                  onPageChanged: onPageChanged,
                  itemBuilder: (_, i) => Image.network(
                    images[i],
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade100,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: Colors.grey.shade50,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ),
                if (discount > 0)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-$discount%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (images.length > 1) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 56,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: images.length,
                itemBuilder: (context, i) {
                  final isSelected = currentIndex == i;
                  return GestureDetector(
                    onTap: () {
                      if (i != currentIndex && i < images.length) {
                        controller.animateToPage(
                          i,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? AppTheme.gold : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.network(
                          images[i],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(Icons.image, color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _TrustBadges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [
      ('Free Delivery', Icons.local_shipping_outlined),
      ('30-Day Returns', Icons.replay_outlined),
      ('Secure Payment', Icons.lock_outline),
    ];
    return Row(
      children: items.map((e) {
        return Expanded(
          child: Column(
            children: [
              Icon(e.$2, size: 22, color: Colors.grey.shade600),
              const SizedBox(height: 6),
              Text(
                e.$1,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppTheme.charcoal,
      ),
    );
  }
}

class _DesignDetailsCard extends StatelessWidget {
  final Product product;

  const _DesignDetailsCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[];
    if (product.material != null && product.material!.isNotEmpty) {
      rows.add(('Metal', product.material!));
    }
    if (product.color != null && product.color!.isNotEmpty) {
      rows.add(('Color', product.color!));
    }
    if (product.sizes != null && product.sizes!.isNotEmpty) {
      rows.add(('Size', product.sizes!.join(', ')));
    } else if (product.size != null && product.size!.isNotEmpty) {
      rows.add(('Size', product.size!));
    }
    if (product.weight != null) {
      rows.add(('Weight', '${product.weight} g'));
    }
    if (product.length != null && product.length!.isNotEmpty) {
      rows.add(('Length', product.length!));
    }
    if (product.category.isNotEmpty) {
      rows.add(('Category', product.categoryDisplay));
    }
    if (product.brand != null && product.brand!.isNotEmpty) {
      rows.add(('Brand', product.brand!));
    }
    if (product.care != null && product.care!.isNotEmpty) {
      rows.add(('Care', product.care!));
    }
    if (product.delivery != null && product.delivery!.isNotEmpty) {
      rows.add(('Delivery', product.delivery!));
    }

    if (rows.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: rows
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        e.$1,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        e.$2,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.charcoal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
