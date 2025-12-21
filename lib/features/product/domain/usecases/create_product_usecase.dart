import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Create product use case
class CreateProductUseCase implements UseCase<Product, CreateProductParams> {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(CreateProductParams params) async {
    return await repository.createProduct(
      code: params.code,
      name: params.name,
      priceBuy: params.priceBuy,
      priceSale: params.priceSale,
      stock: params.stock,
      unit: params.unit,
    );
  }
}

/// Create product parameters
class CreateProductParams extends Equatable {
  final String code;
  final String name;
  final double priceBuy;
  final double priceSale;
  final int stock;
  final String unit;

  const CreateProductParams({
    required this.code,
    required this.name,
    required this.priceBuy,
    required this.priceSale,
    required this.stock,
    required this.unit,
  });

  @override
  List<Object?> get props => [code, name, priceBuy, priceSale, stock, unit];
}
