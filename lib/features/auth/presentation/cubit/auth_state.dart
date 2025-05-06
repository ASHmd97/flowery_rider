// features/auth/presentation/cubit/auth_state.dart

part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final BaseState? signInState;
  final BaseState? forgotPasswordState;
  final BaseState? verifyOtpState;
  final BaseState? resetPasswordState;
  final AuthResponseEntity? authResponse;

  const AuthState({
    required this.signInState,
    this.forgotPasswordState,
    this.verifyOtpState,
    this.resetPasswordState,
    this.authResponse,
  });

  AuthState copyWith({
    BaseState? signInState,
    BaseState? forgotPasswordState,
    BaseState? verifyOtpState,
    BaseState? resetPasswordState,
    AuthResponseEntity? authResponse,
  }) {
    return AuthState(
      signInState: signInState ?? this.signInState,
      forgotPasswordState: forgotPasswordState ?? this.forgotPasswordState,
      verifyOtpState: verifyOtpState ?? this.verifyOtpState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
      authResponse: authResponse ?? this.authResponse,
    );
  }

  @override
  List<Object?> get props => [
        signInState,
        forgotPasswordState,
        verifyOtpState,
        resetPasswordState,
        authResponse,
      ];
}
