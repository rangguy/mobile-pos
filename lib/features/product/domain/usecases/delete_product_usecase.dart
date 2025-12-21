import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

/// Delete product use case
class DeleteProductUseCase implements UseCase<void, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteProductParams params) async {
    return await repository.deleteProduct(params.uuid);
  }
}

/// Delete product parameters
class DeleteProductParams extends Equatable {
  final String uuid;

  const DeleteProductParams(this.uuid);

  @override
  List<Object?> get props => [uuid];
}
