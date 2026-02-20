import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/product.dart';
import '../providers/app_providers.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/loading_placeholder.dart';
import '../widgets/product_card.dart';

/// Home Page - Product grid with category filter tabs
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);
    final cartRepo = ref.watch(cartRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (cartRepo.itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cartRepo.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AppConstants.routeCart);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _CategoryChip(
                  label: AppConstants.categoryAll,
                  isSelected:
                      viewModel.selectedCategory == AppConstants.categoryAll,
                  onTap: () =>
                      viewModel.selectCategory(AppConstants.categoryAll),
                ),
                _CategoryChip(
                  label: AppConstants.categoryRings,
                  isSelected:
                      viewModel.selectedCategory == AppConstants.categoryRings,
                  onTap: () =>
                      viewModel.selectCategory(AppConstants.categoryRings),
                ),
                _CategoryChip(
                  label: AppConstants.categoryNecklaces,
                  isSelected: viewModel.selectedCategory ==
                      AppConstants.categoryNecklaces,
                  onTap: () =>
                      viewModel.selectCategory(AppConstants.categoryNecklaces),
                ),
                _CategoryChip(
                  label: AppConstants.categoryBracelets,
                  isSelected: viewModel.selectedCategory ==
                      AppConstants.categoryBracelets,
                  onTap: () =>
                      viewModel.selectCategory(AppConstants.categoryBracelets),
                ),
              ],
            ),
          ),

          // Product grid or loading/error
          Expanded(
            child: productsState.when(
              data: (products) => _ProductGrid(products: products),
              loading: () => const PageLoadingOverlay(),
              error: (err, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.grey[600]),
                    const SizedBox(height: 16),
                    Text('Something went wrong', style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final List<Product> products;

  const _ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Text(
          'No products in this category',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive: 2 columns on mobile, 3+ on tablet
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppConstants.routeProductDetails,
                  arguments: product.id,
                );
              },
            );
          },
        );
      },
    );
  }
}
