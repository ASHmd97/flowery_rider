// features/auth/domain/repo/auth_repo.dart
import 'package:either_dart/either.dart';
import 'package:flowery_rider/features/auth/domain/entities/auth_reponse.dart';

abstract class AuthRepo {
  //-----------------------------signIn-----------------------------------
  Future<Either<Exception, AuthResponseEntity>> signIn(
      String email, String password, bool rememberMe);

  //-----------------------------Check Login Status-----------------------------------
  Future<bool> isUserLoggedIn();
}
