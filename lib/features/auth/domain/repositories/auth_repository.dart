import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Login with username and password
  /// Returns Either<Failure, (User, String)> where String is the JWT token
  Future<Either<Failure, (User, String)>> login({
    required String username,
    required String password,
  });

  /// Register a new user
  Future<Either<Failure, User>> register({
    required String name,
    required String username,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String email,
  });

  /// Get current authenticated user
  Future<Either<Failure, User>> getCurrentUser();

  /// Get user by UUID
  Future<Either<Failure, User>> getUserByUuid(String uuid);

  /// Logout user
  Future<Either<Failure, void>> logout();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
