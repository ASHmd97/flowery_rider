// features/auth/presentation/cubit/auth_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/features/auth/domain/entities/auth_reponse.dart';
import 'package:flowery_rider/features/auth/domain/repo/auth_repo.dart';
import 'package:flowery_rider/features/auth/domain/use_case/forgetpassword_usecase.dart';
import 'package:flowery_rider/features/auth/domain/use_case/login_usecase.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _signInUseCase;
  final AuthRepo _authRepo;

  // Use cases for forgot password flow
  final ForgotPasswordUseCase? _forgotPasswordUseCase;
  final VerifyOtpCodeUseCase? _verifyOtpCodeUseCase;
  final ResetPasswordUseCase? _resetPasswordUseCase;

  bool rememberMe = false;
  bool _isFormValid = false;

  AuthCubit(this._signInUseCase, this._authRepo,
      [this._forgotPasswordUseCase,
      this._verifyOtpCodeUseCase,
      this._resetPasswordUseCase])
      : super(AuthState(
          signInState: BaseInitialState(),
          forgotPasswordState: BaseInitialState(),
          verifyOtpState: BaseInitialState(),
          resetPasswordState: BaseInitialState(),
          authResponse: null,
        ));

  void setRememberMe(bool value) {
    rememberMe = value;
  }

  void updateFormValidity(bool isValid) {
    _isFormValid = isValid;
  }

  void validateForm(String email, String password) {
    final isValid = email.isNotEmpty &&
        password.isNotEmpty &&
        Validator.emailValidate(email) == null &&
        Validator.passwordValidation(password) == null;

    _isFormValid = isValid;
  }

  bool get isFormValid => _isFormValid;

  // Check if a user is already logged in
  Future<bool> isUserLoggedIn() async {
    final isLoggedIn = await _authRepo.isUserLoggedIn();
    if (isLoggedIn) {
      emit(state.copyWith(
        signInState: BaseSuccessState<AuthResponseEntity>(data: null),
      ));
    }
    return isLoggedIn;
  }

  Future<bool> checkAutoLogin() async {
    final isLoggedIn = await isUserLoggedIn();
    return isLoggedIn;
  }

  Future<void> login(String email, String password) async {
    validateForm(email, password);

    if (!_isFormValid) {
      emit(state.copyWith(
        signInState: BaseErrorState('Please enter valid credentials'),
      ));
      return;
    }

    emit(state.copyWith(signInState: BaseLoadingState()));

    try {
      final result = await _signInUseCase(email, password, rememberMe);

      if (result.isRight) {
        final authResponse = result.right;
        emit(state.copyWith(
          signInState: BaseSuccessState<AuthResponseEntity>(data: authResponse),
          authResponse: authResponse,
        ));
      } else {
        emit(state.copyWith(
          signInState: BaseErrorState(result.left.toString()),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        signInState: BaseErrorState(e.toString()),
      ));
    }
  }

  // Forgot Password Methods

  // 1. Request password reset
  Future<void> requestPasswordReset(String email) async {
    if (email.isEmpty || Validator.emailValidate(email) != null) {
      emit(state.copyWith(
        forgotPasswordState:
            BaseErrorState('Please enter a valid email address'),
      ));
      return;
    }

    emit(state.copyWith(forgotPasswordState: BaseLoadingState()));

    try {
      final result = await _forgotPasswordUseCase!(email);

      if (result.isRight) {
        emit(state.copyWith(
          forgotPasswordState: BaseSuccessState<String>(data: result.right),
        ));
      } else {
        emit(state.copyWith(
          forgotPasswordState: BaseErrorState(result.left.toString()),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        forgotPasswordState: BaseErrorState(e.toString()),
      ));
    }
  }

  // 2. Verify OTP code
  Future<void> verifyOtpCode(String email, String code) async {
    if (code.isEmpty) {
      emit(state.copyWith(
        verifyOtpState: BaseErrorState('Please enter the verification code'),
      ));
      return;
    }

    emit(state.copyWith(verifyOtpState: BaseLoadingState()));

    try {
      final result = await _verifyOtpCodeUseCase!(email, code);

      if (result.isRight) {
        emit(state.copyWith(
          verifyOtpState: BaseSuccessState<String>(data: result.right),
        ));
      } else {
        emit(state.copyWith(
          verifyOtpState: BaseErrorState(result.left.toString()),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        verifyOtpState: BaseErrorState(e.toString()),
      ));
    }
  }

  // 3. Reset Password
  Future<void> resetPassword(
      String email, String password, String confirmPassword) async {
    // Validate passwords
    if (password.isEmpty || Validator.passwordValidation(password) != null) {
      emit(state.copyWith(
        resetPasswordState: BaseErrorState('Please enter a valid password'),
      ));
      return;
    }

    if (password != confirmPassword) {
      emit(state.copyWith(
        resetPasswordState: BaseErrorState('Passwords do not match'),
      ));
      return;
    }

    emit(state.copyWith(resetPasswordState: BaseLoadingState()));

    try {
      final result = await _resetPasswordUseCase!(email, password);

      if (result.isRight) {
        final authResponse = result.right;
        emit(state.copyWith(
          resetPasswordState:
              BaseSuccessState<AuthResponseEntity>(data: authResponse),
          authResponse: authResponse,
        ));
      } else {
        emit(state.copyWith(
          resetPasswordState: BaseErrorState(result.left.toString()),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        resetPasswordState: BaseErrorState(e.toString()),
      ));
    }
  }

  // Reset states when navigating between screens
  void resetForgotPasswordState() {
    emit(state.copyWith(forgotPasswordState: BaseInitialState()));
  }

  void resetVerifyOtpState() {
    emit(state.copyWith(verifyOtpState: BaseInitialState()));
  }

  void resetPasswordResetState() {
    emit(state.copyWith(resetPasswordState: BaseInitialState()));
  }
}
