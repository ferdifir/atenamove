import 'dart:convert';

import 'package:atenamove/model/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer; // Untuk logging yang lebih baik

class SharedPreferencesService {
  static SharedPreferences? _preferences;
  static final SharedPreferencesService _instance = SharedPreferencesService._internal();
  factory SharedPreferencesService() {
    return _instance;
  }

  SharedPreferencesService._internal();

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
    developer.log('SharedPreferences initialized.', name: 'SharedPreferencesService');
  }

  bool get _isInitialized => _preferences != null;

  Future<bool> setString(String key, String value) async {
    if (!_isInitialized) {
      developer.log('SharedPreferences not initialized.', name: 'SharedPreferencesService');
      return false;
    }
    final result = await _preferences!.setString(key, value);
    developer.log('Set String: $key = $value (Success: $result)', name: 'SharedPreferencesService');
    return result;
  }

  Future<UserModel> getUser() async {
    if (!_isInitialized) {
      developer.log('SharedPreferences not initialized.', name: 'SharedPreferencesService');
      return UserModel();
    }
    final result = _preferences!.getString("UserData");
    final user = UserModel.fromJson(json.decode(result!));
    developer.log('Get String: user = $result', name: 'SharedPreferencesService');
    return user;
  }

  Future<String?> getIdArmada() async {
    if (!_isInitialized) {
      developer.log('SharedPreferences not initialized.', name: 'SharedPreferencesService');
      return "";
    }
    final result = _preferences!.getString("IdArmada");
    developer.log('Get String: IdArmada = $result', name: 'SharedPreferencesService');
    return result;
  }

  String? getString(String key) {
    if (!_isInitialized) {
      developer.log('SharedPreferences not initialized.', name: 'SharedPreferencesService');
      return null;
    }
    final value = _preferences!.getString(key);
    developer.log('Get String: $key = $value', name: 'SharedPreferencesService');
    return value;
  }

  bool containsKey(String key) {
    if (!_isInitialized) {
      developer.log('SharedPreferences not initialized.', name: 'SharedPreferencesService');
      return false;
    }
    final result = _preferences!.containsKey(key);
    developer.log('Contains Key: $key (Result: $result)', name: 'SharedPreferencesService');
    return result;
  }

  Future<bool> remove(String key) async {
    if (!_isInitialized) {
      developer.log('SharedPreferences not initialized.', name: 'SharedPreferencesService');
      return false;
    }
    final result = await _preferences!.remove(key);
    developer.log('Remove Key: $key (Success: $result)', name: 'SharedPreferencesService');
    return result;
  }

  Future<bool> clear() async {
    if (!_isInitialized) {
      developer.log('SharedPreferences not initialized.', name: 'SharedPreferencesService');
      return false;
    }
    final result = await _preferences!.clear();
    developer.log('All SharedPreferences data cleared (Success: $result)', name: 'SharedPreferencesService');
    return result;
  }
}
