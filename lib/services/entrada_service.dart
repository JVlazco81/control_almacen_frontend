import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api.dart';

class EntradaService {
  static Future<Map<String, dynamic>> subirInventario(String jsonEntrada) async {
  String baseUrl = await ApiConfig.getBaseUrl();
  final startTime = DateTime.now(); // Tiempo de inicio

  try {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    print("⏳ Iniciando petición POST a $baseUrl/entradas");
    print("📌 Token usado: $token");
    print("📤 JSON enviado: $jsonEntrada");

    final response = await http.post(
      Uri.parse("$baseUrl/entradas"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEntrada,
    );

    final endTime = DateTime.now(); // Tiempo de finalización
    final duration = endTime.difference(startTime);
    print("✅ Respuesta recibida en ${duration.inSeconds} segundos");

    print("🔹 Status Code: ${response.statusCode}");
    print("🔹 Response Body: ${response.body}");

    if (response.statusCode == 201) {
      return {"success": true, "message": "Productos subidos correctamente"};
    } else {
      return {"success": false, "message": "Error: ${response.body}"};
    }
  } catch (e) {
    print("❌ Error en la petición: $e");
    return {"success": false, "message": "Error de conexión"};
  }
}

}
