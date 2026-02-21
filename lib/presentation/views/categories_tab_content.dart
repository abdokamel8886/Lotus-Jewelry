import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/app_navigator.dart';
import '../../domain/entities/product.dart';
import '../providers/app_providers.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/app_footer.dart';
import '../widgets/product_card.dart';

/// Categories tab: category filter + product grid + footer
class CategoriesTabContent extends ConsumerWidget {
  const CategoriesTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(homeViewModelProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    return RefreshIndicator(
      onRefresh: () => viewModel.loadProducts(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            categoriesAsync.when(
              data: (categories) {
                final allCategories = [
                  ('all', 'All'),
                  ...categories.map((c) => (c.id, c.name)),
                ];
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: allCategories
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(e.$2),
                              selected: viewModel.selectedCategory == e.$1,
                              onSelected: (_) => viewModel.selectCategory(e.$1),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
              loading: () => const SizedBox(height: 48),
              error: (_, __) => const SizedBox(height: 48),
            ),
            const SizedBox(height: 20),
            productsState.when(
              data: (products) => _ProductGrid(products: products),
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
                    Text('Could not load products', style: TextStyle(color: Colors.grey.shade700)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            const AppFooter(),
          ],
        ),
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
      return Padding(
        padding: const EdgeInsets.all(48),
        child: Center(
          child: Text(
            'No products in this category',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.58,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () => AppNavigator.goProductDetails(context, product.id),
              );
            },
          ),
        );
      },
    );
  }
}
