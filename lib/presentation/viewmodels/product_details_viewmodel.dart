import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../providers/app_providers.dart';

/// ViewModel for Product Details page - fetches single product
class ProductDetailsViewModel extends StateNotifier<AsyncValue<Product?>> {
  ProductDetailsViewModel(this._productRepository, this.productId)
      : super(const AsyncValue.loading()) {
    loadProduct();
  }

  final ProductRepository _productRepository;
  final String productId;

  Future<void> loadProduct() async {
    state = const AsyncValue.loading();
    try {
      final product = await _productRepository.getProductById(productId);
      state = AsyncValue.data(product);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final productDetailsViewModelProvider =
    StateNotifierProvider.family<ProductDetailsViewModel, AsyncValue<Product?>,
        String>((ref, productId) {
  final repo = ref.watch(productRepositoryProvider);
  return ProductDetailsViewModel(repo, productId);
});
