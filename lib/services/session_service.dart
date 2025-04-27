import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _keyAccessToken = 'access_token';

  static Future<void> saveSession(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
  }

  static Future<String?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
  }
}
