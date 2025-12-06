// lib/controllers/product_controller.dart
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductController {
  final ProductService _service = ProductService();

  // Beranda (all products)
  Future<List<Product>> fetchProducts() {
    return _service.getAllProducts();
  }

  // Produk milik user (My Products)
  Future<List<Product>> fetchMyProducts(int userId) {
    return _service.getMyProducts(userId);
  }

  // Hapus produk milik user
  Future<void> deleteMyProduct(int productId) {
    return _service.deleteProduct(productId);
  }

  // CACHE produk by ID (dipakai di MyOrders)
  final Map<int, Future<Product>> _productFutures = {};

  Future<Product> getProductByIdCached(int productId) {
    _productFutures.putIfAbsent(
      productId,
      () => _service.getProductById(productId),
    );
    return _productFutures[productId]!;
  }

  // DETAIL PRODUK (dipakai ProductDetailPage)
  Future<Product> getProductDetail(int productId) {
    return _service.getProductById(productId);
  }
}
