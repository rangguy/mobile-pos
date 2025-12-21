import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base use case interface
/// 
/// [Type] - The return type
/// [Params] - The parameters required for the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case with no parameters
class NoParams {}
