import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

/// Authentication response model
@JsonSerializable()
class AuthResponseModel {
  final String status;
  final String message;
  final UserModel data;
  final String? token;

  AuthResponseModel({
    required this.status,
    required this.message,
    required this.data,
    this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
