import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api.dart';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html; // solo para web
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

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
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "message": "Productos subidos correctamente",
          "id_entrada": data["id_entrada"]
        };
      } else {
        return {"success": false, "message": "Error: ${response.body}"};
      }
    } catch (e) {
      print("❌ Error en la petición: $e");
      return {"success": false, "message": "Error de conexión"};
    }
  }

  static Future<void> descargarPDFEntrada(int idEntrada) async {
    final baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    final url = Uri.parse("$baseUrl/entradas/vales/$idEntrada?pdf=true");

    final response = await http.get(url, headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      final fileName = "vale_entrada_$idEntrada.pdf";
      final bytes = response.bodyBytes;

      if (kIsWeb) {
        // Web: descarga usando HTML anchor
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // Móvil: guardar local y abrir
        final dir = await getApplicationDocumentsDirectory();
        final file = io.File("${dir.path}/$fileName");
        await file.writeAsBytes(bytes);
        await OpenFile.open(file.path);
      }
    } else {
      throw Exception("Error al descargar el PDF: ${response.statusCode}");
    }
  }
}
