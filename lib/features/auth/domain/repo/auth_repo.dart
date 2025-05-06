// features/auth/domain/repo/auth_repo.dart
import 'package:either_dart/either.dart';
import 'package:flowery_rider/features/auth/domain/entities/auth_reponse.dart';

abstract class AuthRepo {
  //-----------------------------signIn-----------------------------------
  Future<Either<Exception, AuthResponseEntity>> signIn(
      String email, String password, bool rememberMe);

  //-----------------------------Check Login Status-----------------------------------
  Future<bool> isUserLoggedIn();

  //-----------------------------Forgot Password-----------------------------------
  Future<Either<Exception, String>> forgotPassword(String email);

  //-----------------------------Verify OTP Code-----------------------------------
  Future<Either<Exception, String>> verifyOtpCode(String email, String code);

  //-----------------------------Reset Password-----------------------------------
  Future<Either<Exception, AuthResponseEntity>> resetPassword(
      String email, String password);
}
