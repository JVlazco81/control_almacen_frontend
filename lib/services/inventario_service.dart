import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/producto.dart';
import '../core/api.dart';

class InventarioService {
  static Future<List<Producto>> obtenerInventario() async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await http.get(
      Uri.parse("$baseUrl/inventario"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Producto.fromJson(item)).toList();
    } else {
      throw Exception("Error al obtener el inventario: ${response.body}");
    }
  }

  static Future<void> actualizarProducto(
    int id,
    Map<String, dynamic> data,
  ) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await http.patch(
      Uri.parse("$baseUrl/inventario/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al actualizar producto: ${response.body}");
    }
  }

  static Future<void> eliminarProducto(int id) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await http.delete(
      Uri.parse("$baseUrl/inventario/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar producto: ${response.body}");
    }
  }
}
