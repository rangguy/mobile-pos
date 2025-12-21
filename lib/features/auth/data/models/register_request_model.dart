import 'package:json_annotation/json_annotation.dart';

part 'register_request_model.g.dart';

/// Register request model
@JsonSerializable()
class RegisterRequestModel {
  final String name;
  final String username;
  final String password;
  @JsonKey(name: 'confirm_password')
  final String confirmPassword;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String email;

  RegisterRequestModel({
    required this.name,
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.email,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
