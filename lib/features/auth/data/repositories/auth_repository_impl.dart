import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

/// Authentication repository implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, (User, String)>> login({
    required String username,
    required String password,
  }) async {
    try {
      final request = LoginRequestModel(
        username: username,
        password: password,
      );

      final response = await remoteDataSource.login(request);

      if (response.token != null) {
        // Save token to local storage
        await localDataSource.saveToken(response.token!);

        return Right((response.data.toEntity(), response.token!));
      } else {
        return const Left(Failure.server(
          message: 'Token not received from server',
        ));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String username,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String email,
  }) async {
    try {
      final request = RegisterRequestModel(
        name: name,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
        email: email,
      );

      final response = await remoteDataSource.register(request);

      return Right(response.data.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final response = await remoteDataSource.getCurrentUser();
      return Right(response.data.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserByUuid(String uuid) async {
    try {
      final response = await remoteDataSource.getUserByUuid(uuid);
      return Right(response.data.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.deleteToken();
      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await localDataSource.isAuthenticated();
  }

  /// Handle Dio errors and convert to Failure
  Failure _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const Failure.network(
        message: 'Connection timeout. Please check your internet connection.',
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return const Failure.network(
        message: 'No internet connection. Please check your network settings.',
      );
    }

    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    if (statusCode == 401) {
      return Failure.unauthorized(
        message: responseData?['message'] ?? 'Unauthorized',
      );
    }

    if (statusCode == 404) {
      return Failure.notFound(
        message: responseData?['message'] ?? 'Resource not found',
      );
    }

    if (statusCode == 422) {
      final errors = responseData?['data'] as List?;
      final validationErrors = errors
          ?.map((e) => ValidationError.fromJson(e as Map<String, dynamic>))
          .toList();

      return Failure.validation(
        message: responseData?['message'] ?? 'Validation error',
        errors: validationErrors,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return Failure.server(
        message: responseData?['message'] ?? 'Server error',
        statusCode: statusCode,
      );
    }

    return Failure.unknown(
      message: error.message ?? 'An unknown error occurred',
    );
  }
}
