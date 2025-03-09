import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static String _baseUrl = "http://192.168.1.69:80/api"; // Sin puerto

  static Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("api_base_url") ?? _baseUrl;
  }

  // Nuevo método para obtener origen
  static Future<String> getOrigin() async {
    final baseUrl = await getBaseUrl();
    return baseUrl.replaceFirst("/api", "");
  }
}