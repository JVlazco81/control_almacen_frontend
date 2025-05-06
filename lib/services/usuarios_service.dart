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

  static Future<List<User>> obtenerUsuarios() async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await http.get(
      Uri.parse("$baseUrl/usuarios"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception("Error al obtener usuarios: ${response.body}");
    }
  }

  static Future<void> eliminarUsuario(int idUsuario) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await http.delete(
      Uri.parse("$baseUrl/usuarios/$idUsuario"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar usuario: ${jsonDecode(response.body)}");
    }
  }

  static Future<User> obtenerUsuarioPorId(int idUsuario) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await http.get(
      Uri.parse("$baseUrl/usuarios/$idUsuario"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception("Error al obtener usuario: ${response.body}");
    }
  }

  static Future<void> actualizarUsuario(int idUsuario, Map<String, dynamic> data) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await http.patch(
      Uri.parse("$baseUrl/usuarios/$idUsuario"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      try {
        final jsonData = jsonDecode(response.body);
        final errorMsg = jsonData['error'] ?? 'Error desconocido';
        throw Exception(errorMsg);
      } catch (_) {
        throw Exception('Error inesperado al actualizar usuario.');
      }
    }
  }

}