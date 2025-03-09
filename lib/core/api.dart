import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static String _baseUrl = "http://192.168.1.66:80/api"; // CAMBIAR A SU IP LOCAL

  // Obtener la URL actual
  static Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("api_base_url") ?? _baseUrl;
  }
}
