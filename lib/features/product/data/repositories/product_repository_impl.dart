import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_request_model.dart';

/// Product repository implementation
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      final response = await remoteDataSource.getAllProducts();
      final products =
          response.products.map((model) => model.toEntity()).toList();
      return Right(products);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsPagination({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response =
          await remoteDataSource.getProductsPagination(page, limit);
      final products =
          response.products.map((model) => model.toEntity()).toList();
      return Right(products);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductByUuid(String uuid) async {
    try {
      final response = await remoteDataSource.getProductByUuid(uuid);
      final product = response.product;
      if (product != null) {
        return Right(product.toEntity());
      } else {
        return const Left(Failure.notFound(message: 'Product not found'));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductByCode(String code) async {
    try {
      final response = await remoteDataSource.getProductByCode(code);
      final product = response.product;
      if (product != null) {
        return Right(product.toEntity());
      } else {
        return const Left(Failure.notFound(message: 'Product not found'));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct({
    String? code,
    required String name,
    required int priceBuy,
    required int priceSale,
    required int stock,
    required String unit,
  }) async {
    try {
      final request = ProductRequestModel(
        code: code,
        name: name,
        priceBuy: priceBuy,
        priceSale: priceSale,
        stock: stock,
        unit: unit,
      );

      final response = await remoteDataSource.createProduct(request);
      final product = response.product;
      if (product != null) {
        return Right(product.toEntity());
      } else {
        return const Left(Failure.server(message: 'Failed to create product'));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct({
    required String uuid,
    String? code,
    required String name,
    required int priceBuy,
    required int priceSale,
    required int stock,
    required String unit,
  }) async {
    try {
      final request = ProductRequestModel(
        code: code,
        name: name,
        priceBuy: priceBuy,
        priceSale: priceSale,
        stock: stock,
        unit: unit,
      );

      final response = await remoteDataSource.updateProduct(uuid, request);
      final product = response.product;
      if (product != null) {
        return Right(product.toEntity());
      } else {
        return const Left(Failure.server(message: 'Failed to update product'));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String uuid) async {
    try {
      await remoteDataSource.deleteProduct(uuid);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
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
        message: responseData?['message'] ?? 'Product not found',
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
