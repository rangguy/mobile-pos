import 'package:equatable/equatable.dart';

/// User entity
class User extends Equatable {
  final String uuid;
  final String name;
  final String username;
  final String email;
  final String? role;
  final String phoneNumber;

  const User({
    required this.uuid,
    required this.name,
    required this.username,
    required this.email,
    this.role,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [uuid, name, username, email, role, phoneNumber];
}
