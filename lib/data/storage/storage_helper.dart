import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> _ensurePrefs() async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  static Future<void> save(String key, dynamic value) async {
    final prefs = await _ensurePrefs();

    if (value is String) {
      await prefs.setString(key, value);
    } else {
      final str = jsonEncode(value);
      await prefs.setString(key, str);
    }
  }

  static dynamic get(String key) {
    final data = _prefs?.getString(key);
    if (data == null) return null;

    try {
      return jsonDecode(data);
    } catch (_) {
      return data; // لو String عادي
    }
  }

  static Future<void> remove(String key) async {
    final prefs = await _ensurePrefs();
    await prefs.remove(key);
  }

  static Future<void> clearAll() async {
    final prefs = await _ensurePrefs();
    await prefs.clear();
  }
}
