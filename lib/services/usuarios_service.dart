import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api.dart';
import '../models/user.dart';

class UsuariosService {
  static Future<User> registrarUsuario({
    required int idRol,
    required String primerNombre,
    required String segundoNombre,
    required String primerApellido,
    required String segundoApellido,
    required String password,
  }) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final body = {
      "id_rol": idRol,
      "primer_nombre": primerNombre,
      "segundo_nombre": segundoNombre,
      "primer_apellido": primerApellido,
      "segundo_apellido": segundoApellido,
      "usuario_password": password,
    };

    final response = await http.post(
      Uri.parse("$baseUrl/usuarios"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      return User.fromJson(jsonData["usuario"]);
    } else {
      throw Exception("Error al registrar usuario: ${response.body}");
    }
  }
}