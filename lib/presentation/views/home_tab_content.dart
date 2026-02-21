import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/product.dart';
import '../providers/app_providers.dart';
import 'main_shell_view.dart';
import '../widgets/app_footer.dart';

/// Home tab: large top-products carousel, then compact product grid + footer
class HomeTabContent extends ConsumerWidget {
  const HomeTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topProductsAsync = ref.watch(topProductsProvider);
    final productsAsync = ref.watch(homeProductsProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          topProductsAsync.when(
            data: (topProducts) {
              if (topProducts.isEmpty) return const SizedBox.shrink();
              return _TopProductsCarousel(
                products: topProducts,
                onGoToCatalog: () =>
                    ref.read(mainShellTabIndexProvider.notifier).state = 1,
              );
            },
            loading: () => SizedBox(
              height: MediaQuery.of(context).size.height * 0.42,
              child: const Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Products',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          productsAsync.when(
            data: (products) => _HomeProductGrid(products: products),
            loading: () => const SizedBox(
              height: 280,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.grey.shade500),
                  const SizedBox(height: 16),
                  Text(
                    'Could not load products',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
          const AppFooter(),
        ],
      ),
    );
  }
}

/// Large hero-style carousel: one top product per page, left text + right image
class _TopProductsCarousel extends StatefulWidget {
  final List<Product> products;
  final VoidCallback onGoToCatalog;

  const _TopProductsCarousel({
    required this.products,
    required this.onGoToCatalog,
  });

  @override
  State<_TopProductsCarousel> createState() => _TopProductsCarouselState();
}

class _TopProductsCarouselState extends State<_TopProductsCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (widget.products.length <= 1) return;
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % widget.products.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.42;
    return Column(
      children: [
        SizedBox(
          height: height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (i) {
              setState(() => _currentPage = i);
              _startAutoPlay(); // reset timer on manual scroll
            },
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _HeroTopCard(
                  product: widget.products[index],
                  onView: () => Navigator.of(context).pushNamed(
                    AppConstants.routeProductDetails,
                    arguments: widget.products[index].id,
                  ),
                  onGoToCatalog: widget.onGoToCatalog,
                ),
              );
            },
          ),
        ),
        if (widget.products.length > 1) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.products.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _currentPage == i ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: _currentPage == i
                      ? AppTheme.gold
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

}

/// Single hero card: left grey (title, description, button), right white (image)
class _HeroTopCard extends StatelessWidget {
  final Product product;
  final VoidCallback onView;
  final VoidCallback onGoToCatalog;

  const _HeroTopCard({
    required this.product,
    required this.onView,
    required this.onGoToCatalog,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (product.badge != null && product.badge!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        product.badge!,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.charcoal,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.45,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        '\$${product.finalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.gold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: onView,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.charcoal,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('View'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: onGoToCatalog,
                    child: const Text('GO TO CATALOG'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade100,
                  child: Icon(Icons.image, size: 64, color: Colors.grey.shade400),
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
          ),
        ],
      ),
    );
  }
}

/// Compact product grid: 4 cards per row (or 2 on mobile), image + title + description
class _HomeProductGrid extends StatelessWidget {
  final List<Product> products;

  const _HomeProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(48),
        child: Center(
          child: Text(
            'No products',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 700 ? 4 : 2;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.68,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _CompactProductCard(
                product: product,
                onTap: () => Navigator.of(context).pushNamed(
                  AppConstants.routeProductDetails,
                  arguments: product.id,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Compact card: square image, bold title, short description (like reference image)
class _CompactProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _CompactProductCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Image.network(
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
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
