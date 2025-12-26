import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

/// Authentication BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GetUserProfileUseCase getUserProfileUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.getUserProfileUseCase,
    required this.checkAuthStatusUseCase,
    required this.logoutUseCase,
  }) : super(const AuthState.initial()) {
    on<AuthEventLogin>(_onLogin);
    on<AuthEventRegister>(_onRegister);
    on<AuthEventGetUserProfile>(_onGetUserProfile);
    on<AuthEventCheckStatus>(_onCheckStatus);
    on<AuthEventLogout>(_onLogout);
  }

  Future<void> _onLogin(
    AuthEventLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await loginUseCase(
      LoginParams(
        username: event.username,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthState.error(failure.toString())),
      (data) {
        final (user, token) = data;
        emit(AuthState.authenticated(user));
      },
    );
  }

  Future<void> _onRegister(
    AuthEventRegister event,
    Emitter<AuthState> emit,
  ) async {
    // Capture the current authenticated user before registration
    User? currentUser;
    state.whenOrNull(
      authenticated: (user) => currentUser = user,
      profileLoaded: (user) => currentUser = user,
    );

    emit(const AuthState.loading());

    final result = await registerUseCase(
      RegisterParams(
        name: event.name,
        username: event.username,
        password: event.password,
        confirmPassword: event.confirmPassword,
        phoneNumber: event.phoneNumber,
        email: event.email,
      ),
    );

    result.fold(
      (failure) => emit(AuthState.error(failure.toString())),
      (newUser) {
        // Emit registerSuccess with the newly registered user for UI feedback
        emit(AuthState.registerSuccess(newUser));

        // Immediately restore the current authenticated user to prevent auto-login
        if (currentUser != null) {
          emit(AuthState.authenticated(currentUser!));
        }
      },
    );
  }

  /// Handle get user profile event
  Future<void> _onGetUserProfile(
    AuthEventGetUserProfile event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await getUserProfileUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthState.error(failure.toString())),
      (user) => emit(AuthState.profileLoaded(user)),
    );
  }

  Future<void> _onCheckStatus(
    AuthEventCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await checkAuthStatusUseCase(NoParams());

    result.fold(
      (failure) => emit(const AuthState.unauthenticated()),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onLogout(
    AuthEventLogout event,
    Emitter<AuthState> emit,
  ) async {
    await logoutUseCase(NoParams());
    emit(const AuthState.unauthenticated());
  }
}
