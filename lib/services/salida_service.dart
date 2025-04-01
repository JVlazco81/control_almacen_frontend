import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api.dart';

class SalidaService {
  static Future<Map<String, dynamic>> registrarSalida(String jsonSalida) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final startTime = DateTime.now();

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token");

      print("📤 Enviando POST a $baseUrl/salidas/generar");
      print("🔑 Token: $token");
      print("📦 Payload: $jsonSalida");

      final response = await http.post(
        Uri.parse("$baseUrl/salidas/generar"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonSalida,
      );

      final duration = DateTime.now().difference(startTime);
      print("✅ Respondió en ${duration.inMilliseconds} ms");
      print("📥 Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {"success": true, "message": "Salida registrada correctamente"};
      } else {
        return {"success": false, "message": response.body};
      }
    } catch (e) {
      print("❌ Error: $e");
      return {"success": false, "message": "Error de conexión"};
    }
  }
}