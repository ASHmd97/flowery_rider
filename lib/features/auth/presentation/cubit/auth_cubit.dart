// features/auth/presentation/cubit/auth_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/features/auth/domain/entities/auth_reponse.dart';
import 'package:flowery_rider/features/auth/domain/repo/auth_repo.dart';
import 'package:flowery_rider/features/auth/domain/use_case/login_usecase.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _signInUseCase;
  final AuthRepo _authRepo;

  bool rememberMe = false;
  bool _isFormValid = false;

  AuthCubit(this._signInUseCase, this._authRepo)
      : super(AuthState(
          signInState: BaseInitialState(),
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
}
