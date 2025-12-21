part of 'auth_bloc.dart';

/// Authentication states
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthStateInitial;
  const factory AuthState.loading() = AuthStateLoading;
  const factory AuthState.authenticated(User user) = AuthStateAuthenticated;
  const factory AuthState.registerSuccess(User user) = AuthStateRegisterSuccess;
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
  const factory AuthState.error(String message) = AuthStateError;
}
