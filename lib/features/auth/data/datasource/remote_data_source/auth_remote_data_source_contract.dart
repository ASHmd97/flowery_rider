// features/auth/data/datasource/remote_data_source/auth_remote_data_source_contract.dart
import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/auth/data/model/login/login_response.dart';

abstract class AuthRemoteDataSourceContract {
  Future<Either<ApiException, LoginResponse>> signIn(
      String email, String password);
}
