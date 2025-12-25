import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Update product use case
class UpdateProductUseCase implements UseCase<Product, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(UpdateProductParams params) async {
    return await repository.updateProduct(
      uuid: params.uuid,
      code: params.code,
      name: params.name,
      priceBuy: params.priceBuy,
      priceSale: params.priceSale,
      stock: params.stock,
      unit: params.unit,
    );
  }
}

/// Update product parameters
class UpdateProductParams extends Equatable {
  final String uuid;
  final String? code;
  final String name;
  final int priceBuy;
  final int priceSale;
  final int stock;
  final String unit;

  const UpdateProductParams({
    required this.uuid,
    this.code,
    required this.name,
    required this.priceBuy,
    required this.priceSale,
    required this.stock,
    required this.unit,
  });

  @override
  List<Object?> get props =>
      [uuid, code, name, priceBuy, priceSale, stock, unit];
}
