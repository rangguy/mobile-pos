import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';

/// Product repository interface
abstract class ProductRepository {
  /// Get all products without pagination
  Future<Either<Failure, List<Product>>> getAllProducts();

  /// Get products with pagination
  Future<Either<Failure, List<Product>>> getProductsPagination({
    int page = 1,
    int limit = 10,
  });

  /// Get product by UUID
  Future<Either<Failure, Product>> getProductByUuid(String uuid);

  /// Get product by code (for barcode scanning)
  Future<Either<Failure, Product>> getProductByCode(String code);

  /// Create a new product
  Future<Either<Failure, Product>> createProduct({
    String? code,
    required String name,
    required int priceBuy,
    required int priceSale,
    required int stock,
    required String unit,
  });

  /// Update an existing product
  Future<Either<Failure, Product>> updateProduct({
    required String uuid,
    String? code,
    required String name,
    required int priceBuy,
    required int priceSale,
    required int stock,
    required String unit,
  });

  /// Delete a product
  Future<Either<Failure, void>> deleteProduct(String uuid);
}
