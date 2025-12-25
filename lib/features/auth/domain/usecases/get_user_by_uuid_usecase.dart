import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting user by UUID
class GetUserByUuidUseCase implements UseCase<User, GetUserByUuidParams> {
  final AuthRepository repository;

  GetUserByUuidUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(GetUserByUuidParams params) async {
    return await repository.getUserByUuid(params.uuid);
  }
}

class GetUserByUuidParams extends Equatable {
  final String uuid;

  const GetUserByUuidParams({required this.uuid});

  @override
  List<Object?> get props => [uuid];
}
