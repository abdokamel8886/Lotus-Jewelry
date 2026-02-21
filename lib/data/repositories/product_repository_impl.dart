import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../services/firebase_realtime_db_manager.dart';

/// Product repository - fetches products from Firebase Realtime Database
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({FirebaseRealtimeDbManager? dbManager})
      : _dbManager = dbManager ?? FirebaseRealtimeDbManager();

  final FirebaseRealtimeDbManager _dbManager;

  @override
  Future<List<Product>> getProducts({String? category}) async {
    return _dbManager.getProducts(category: category);
  }

  @override
  Future<Product?> getProductById(String id) async {
    return _dbManager.getProductById(id);
  }
}
