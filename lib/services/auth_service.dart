import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api.dart';
import '../models/user.dart';

class AuthService {
  // Iniciar sesión y obtener token
  static Future<bool> login(User user) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final loginresponse = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(user.toJson()),
    );

    print("Status Code: ${loginresponse.statusCode}");
    print("Response Body: ${loginresponse.body}");
    print("📢 URL de la API: $baseUrl/auth/login");

    if (loginresponse.statusCode == 200) {
      final data = jsonDecode(loginresponse.body);
      String token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("auth_token", token);
      return true;
    }
    return false;
  }

  //  Obtener token guardado
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  // Cerrar sesión y eliminar token
  static Future<void> logout() async {
    String? token = await getToken();
    if (token != null) {
      String baseUrl = await ApiConfig.getBaseUrl();
      await http.post(
        Uri.parse("$baseUrl/auth/logout"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
  }
}