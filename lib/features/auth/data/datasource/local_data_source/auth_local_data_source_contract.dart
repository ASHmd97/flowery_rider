<<<<<<< HEAD
// features/auth/data/datasource/local_data_source/auth_local_data_source_contract.dart
abstract class AuthLocalDataSourceContract {
  //-----------------------------Token-----------------------------------
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<String?> checkSavedToken();
  //-----------------------------cacheRememberMe-----------------------------------
  Future<void> cacheRememberMe(bool rememberMe);
  bool getRememberMe();
  Future<void> deleteRememberMe();
}
=======
// features/auth/data/datasource/local_data_source/auth_local_data_source_contract.dart
abstract class AuthLocalDataSourceContract {
  //-----------------------------Token-----------------------------------
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<String?> checkSavedToken();
  //-----------------------------cacheRememberMe-----------------------------------
  Future<void> cacheRememberMe(bool rememberMe);
  bool getRememberMe();
  Future<void> deleteRememberMe();
}
>>>>>>> 3c9c483 (OrderSuccess)
