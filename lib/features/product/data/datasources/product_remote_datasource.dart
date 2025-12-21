import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/product_request_model.dart';
import '../models/product_response_model.dart';

part 'product_remote_datasource.g.dart';

/// Product remote data source
@RestApi()
abstract class ProductRemoteDataSource {
  factory ProductRemoteDataSource(
    Dio dio, {
    String? baseUrl,
  }) = _ProductRemoteDataSource;

  /// Get all products
  @GET(ApiConstants.products)
  Future<ProductResponseModel> getAllProducts();

  /// Get products with pagination
  @GET(ApiConstants.productsPagination)
  Future<ProductResponseModel> getProductsPagination(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  /// Get product by UUID
  @GET(ApiConstants.productByUuid)
  Future<ProductResponseModel> getProductByUuid(@Path('uuid') String uuid);

  /// Get product by code (for barcode scanning)
  @GET(ApiConstants.productByCode)
  Future<ProductResponseModel> getProductByCode(@Path('code') String code);

  /// Create product
  @POST(ApiConstants.products)
  Future<ProductResponseModel> createProduct(
      @Body() ProductRequestModel request);

  /// Update product
  @PUT(ApiConstants.productByUuid)
  Future<ProductResponseModel> updateProduct(
    @Path('uuid') String uuid,
    @Body() ProductRequestModel request,
  );

  /// Delete product
  @DELETE(ApiConstants.productByUuid)
  Future<ProductResponseModel> deleteProduct(@Path('uuid') String uuid);
}
