import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Register use case
class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      name: params.name,
      username: params.username,
      password: params.password,
      confirmPassword: params.confirmPassword,
      phoneNumber: params.phoneNumber,
      email: params.email,
    );
  }
}

/// Register parameters
class RegisterParams extends Equatable {
  final String name;
  final String username;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String email;

  const RegisterParams({
    required this.name,
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.email,
  });

  @override
  List<Object?> get props => [
        name,
        username,
        password,
        confirmPassword,
        phoneNumber,
        email,
      ];
}
