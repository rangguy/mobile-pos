import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// User model for data layer
@JsonSerializable()
class UserModel {
  final String uuid;
  final String name;
  final String username;
  final String email;
  final String? role;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  UserModel({
    required this.uuid,
    required this.name,
    required this.username,
    required this.email,
    this.role,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Convert to domain entity
  User toEntity() {
    return User(
      uuid: uuid,
      name: name,
      username: username,
      email: email,
      role: role,
      phoneNumber: phoneNumber,
    );
  }

  /// Create from domain entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      uuid: user.uuid,
      name: user.name,
      username: user.username,
      email: user.email,
      role: user.role,
      phoneNumber: user.phoneNumber,
    );
  }
}
