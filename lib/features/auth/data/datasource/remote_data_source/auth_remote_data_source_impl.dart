// features/auth/data/datasource/remote_data_source/auth_remote_data_source_impl.dart

import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/app_data/api/api_client.dart';
import 'package:flowery_rider/core/app_data/api/api_constants.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/core/logger/app_logger.dart';
import 'package:flowery_rider/features/auth/data/datasource/remote_data_source/auth_remote_data_source_contract.dart';
import 'package:flowery_rider/features/auth/data/model/login/login_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

//---------------------------------signIn-----------------------------------
  @override
  Future<Either<ApiException, LoginResponse>> signIn(
      String email, String password) async {
    try {
      final response = await _apiClient.post(
        // 'auth/signin',
        ApiConstants.loginEndPoint,
        data: {
          'email': email,
          'password': password,
        },
        requiresToken: false,
      );

      final signInResponse = LoginResponse.fromJson(response);
      return Right(signInResponse);
    } catch (e) {
      Log.e('Error during sign in: $e');
      return Left(ApiException(message: 'Failed to sign in: $e'));
    }
  }
}
