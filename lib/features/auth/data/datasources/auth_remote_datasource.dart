import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

part 'auth_remote_datasource.g.dart';

/// Authentication remote data source
@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(
    Dio dio, {
    String? baseUrl,
  }) = _AuthRemoteDataSource;

  /// Login
  @POST(ApiConstants.login)
  Future<AuthResponseModel> login(@Body() LoginRequestModel request);

  /// Register
  @POST(ApiConstants.register)
  Future<AuthResponseModel> register(@Body() RegisterRequestModel request);

  /// Get current user
  @GET(ApiConstants.getCurrentUser)
  Future<AuthResponseModel> getCurrentUser();

  /// Get user by UUID
  @GET(ApiConstants.getUserByUuid)
  Future<AuthResponseModel> getUserByUuid(@Path('uuid') String uuid);
}
