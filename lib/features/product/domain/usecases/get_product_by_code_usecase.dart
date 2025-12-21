import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Get product by code use case (for barcode scanning)
class GetProductByCodeUseCase implements UseCase<Product, ProductCodeParams> {
  final ProductRepository repository;

  GetProductByCodeUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(ProductCodeParams params) async {
    return await repository.getProductByCode(params.code);
  }
}

/// Product code parameters
class ProductCodeParams extends Equatable {
  final String code;

  const ProductCodeParams(this.code);

  @override
  List<Object?> get props => [code];
}
