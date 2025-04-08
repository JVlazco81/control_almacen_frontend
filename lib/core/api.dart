import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    if (!dotenv.isInitialized) {
      throw Exception("❌ dotenv no ha sido inicializado");
    }
    return dotenv.env['API_BASE_URL'] ?? "http://localhost/api";
  }

  static Future<String> getBaseUrl() async {
    return baseUrl;
  }

  static Future<String> getOrigin() async {
    return baseUrl.replaceFirst("/api", "");
  }
}