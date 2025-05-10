import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class LocalStorageClient {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;
  static const String secureKeyPrefix = 'secure_fallback_';

  LocalStorageClient(this.sharedPreferences, this.secureStorage);

  // Basic SharedPreferences operations
  Future<bool> saveData(String key, String value) async {
    try {
      return await sharedPreferences.setString(key, value);
    } catch (_) {
      return false;
    }
  }

  String? getData(String key) {
    return sharedPreferences.getString(key);
  }

  Future<bool> deleteData(String key) async {
    try {
      return await sharedPreferences.remove(key);
    } catch (_) {
      return false;
    }
  }

  // Secure storage with fallback
  Future<bool> saveSecuredData(String key, String value) async {
    try {
      await secureStorage.write(key: key, value: value);
      return true;
    } catch (_) {
      return sharedPreferences.setString('$secureKeyPrefix$key', value);
    }
  }

  Future<String?> getSecuredData(String key) async {
    try {
      return await secureStorage.read(key: key);
    } catch (_) {
      return sharedPreferences.getString('$secureKeyPrefix$key');
    }
  }

  Future<bool> deleteSecuredData(String key) async {
    try {
      await secureStorage.delete(key: key);
      await sharedPreferences.remove('$secureKeyPrefix$key');
      return true;
    } catch (_) {
      return sharedPreferences.remove('$secureKeyPrefix$key');
    }
  }

  // Remember me functionality
  bool getRememberMe() {
    return sharedPreferences.getBool('rememberUser') ?? false;
  }

  Future<bool> saveRememberMe(bool rememberMe) async {
    return sharedPreferences.setBool('rememberUser', rememberMe);
  }
}
