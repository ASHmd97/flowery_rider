// features/auth/data/repo/auth_repo.dart

import 'package:either_dart/either.dart';
import 'package:flowery_rider/features/auth/data/datasource/local_data_source/auth_local_data_source_contract.dart';
import 'package:flowery_rider/features/auth/data/datasource/remote_data_source/auth_remote_data_source_contract.dart';
import 'package:flowery_rider/features/auth/domain/entities/auth_reponse.dart';
import 'package:flowery_rider/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepositoryImpl implements AuthRepo {
  final AuthRemoteDataSourceContract _remoteDataSource;
  final AuthLocalDataSourceContract _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Exception, AuthResponseEntity>> signIn(
      String email, String password, bool rememberMe) async {
    try {
      final result = await _remoteDataSource.signIn(email, password);

      return result.fold(
        (exception) => Left(exception),
        (loginResponse) {
          if (loginResponse.token != null) {
            if (rememberMe) {
              _localDataSource.cacheToken(loginResponse.token!);
              _localDataSource.cacheRememberMe(true);
            } else {
              _localDataSource.deleteToken();
              _localDataSource.cacheRememberMe(false);
            }

            return Right(AuthResponseEntity(
              message: loginResponse.message,
              token: loginResponse.token,
            ));
          } else {
            return Left(Exception('Authentication failed: Token is null'));
          }
        },
      );
    } catch (e) {
      return Left(Exception('Authentication failed: ${e.toString()}'));
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      final token = await _localDataSource.checkSavedToken();
      final rememberMe = _localDataSource.getRememberMe();
      return token != null && rememberMe;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Exception, String>> forgotPassword(String email) async {
    try {
      final result = await _remoteDataSource.forgotPassword(email);

      return result.fold(
        (exception) => Left(Exception(exception.message)),
        (message) => Right(message),
      );
    } catch (e) {
      return Left(Exception('Forgot password request failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, String>> verifyOtpCode(
      String email, String code) async {
    try {
      final result = await _remoteDataSource.verifyOtpCode(email, code);

      return result.fold(
        (exception) => Left(Exception(exception.message)),
        (status) => Right(status),
      );
    } catch (e) {
      return Left(Exception('OTP verification failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, AuthResponseEntity>> resetPassword(
      String email, String password) async {
    try {
      final result = await _remoteDataSource.resetPassword(email, password);

      return result.fold(
        (exception) => Left(Exception(exception.message)),
        (loginResponse) {
          if (loginResponse.token != null) {
            // Save the new token to local storage after password reset
            _localDataSource.cacheToken(loginResponse.token!);
            _localDataSource.cacheRememberMe(true);

            return Right(AuthResponseEntity(
              message: loginResponse.message,
              token: loginResponse.token,
            ));
          } else {
            return Left(Exception('Password reset failed: Token is null'));
          }
        },
      );
    } catch (e) {
      return Left(Exception('Password reset failed: ${e.toString()}'));
    }
  }
}
