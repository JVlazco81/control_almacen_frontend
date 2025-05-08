import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api.dart';
import '../models/user.dart';

class AuthService {
  // Iniciar sesión y obtener token + usuario
  static Future<bool> login(User user, String password) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(user.toJsonLogin(password)),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Guardar token y usuario en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", data["token"]);
      await prefs.setString("user_data", jsonEncode(data["user"]));
      return true;
    }
    return false;
  }

  // Obtener token guardado
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    return token;
  }

  // Obtener datos del usuario
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString("user_data");

    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Cerrar sesión y eliminar datos guardados
  static Future<void> logout() async {
    String? token = await getToken();
    if (token != null) {
      String baseUrl = await ApiConfig.getBaseUrl();
      await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("access_token");
    await prefs.remove("user_data");
  }
}
