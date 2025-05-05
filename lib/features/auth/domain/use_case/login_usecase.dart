// features/auth/domain/use_case/login_usecase.dart
import 'package:either_dart/either.dart';
import 'package:flowery_rider/features/auth/domain/entities/auth_reponse.dart';
import '../repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final AuthRepo _authRepo;

  LoginUseCase(this._authRepo);

  Future<Either<Exception, AuthResponseEntity>> call(
      String email, String password, bool rememberMe) async {
    return await _authRepo.signIn(email, password, rememberMe);
  }
}
