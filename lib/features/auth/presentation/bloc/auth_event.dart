part of 'auth_bloc.dart';

/// Authentication events
@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.login({
    required String username,
    required String password,
  }) = AuthEventLogin;

  const factory AuthEvent.register({
    required String name,
    required String username,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String email,
  }) = AuthEventRegister;

  const factory AuthEvent.getUserProfile() = AuthEventGetUserProfile;

  const factory AuthEvent.checkStatus() = AuthEventCheckStatus;

  const factory AuthEvent.logout() = AuthEventLogout;
}
