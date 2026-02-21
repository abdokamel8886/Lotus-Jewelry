import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../providers/app_providers.dart';

/// ViewModel for Home - products and category filter (category id: "all" | "rings" | "necklaces" | "bracelets")
class HomeViewModel extends StateNotifier<AsyncValue<List<Product>>> {
  HomeViewModel(this._productRepository) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  final ProductRepository _productRepository;

  String _selectedCategory = 'all';

  String get selectedCategory => _selectedCategory;

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final products = await _productRepository.getProducts(
        category: _selectedCategory == 'all' ? null : _selectedCategory,
      );
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> selectCategory(String category) async {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    await loadProducts();
  }
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, AsyncValue<List<Product>>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return HomeViewModel(repo);
});
