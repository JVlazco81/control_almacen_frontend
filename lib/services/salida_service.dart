import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html; // solo para web
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class SalidaService {
  static Future<Map<String, dynamic>> registrarSalida(String jsonSalida) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final startTime = DateTime.now();

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token");

      final response = await http.post(
        Uri.parse("$baseUrl/salidas"),
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
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "message": data["message"] ?? "Salida registrada correctamente",
          "id_salida": data["id_salida"]
        };
      } else {
        return {"success": false, "message": response.body};
      }
    } catch (e) {
      return {"success": false, "message": "Error de conexión"};
    }
  }

  static Future<void> descargarPDFSalida(int idSalida) async {
    final baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    final url = Uri.parse("$baseUrl/salidas/vales/$idSalida?pdf=true");

    final response = await http.get(url, headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      final fileName = "vale_salida_$idSalida.pdf";
      final bytes = response.bodyBytes;

      if (kIsWeb) {
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = io.File("${dir.path}/$fileName");
        await file.writeAsBytes(bytes);
        await OpenFile.open(file.path);
      }
    } else {
      throw Exception("Error al descargar el PDF de salida: ${response.statusCode}");
    }
  }

  static Future<List<String>> buscarDepartamentos(String query) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await http.get(
      Uri.parse("$baseUrl/departamentos?query=$query"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<String>((item) => item['nombre_departamento'].toString()).toList();
    } else {
      throw Exception("Error al buscar departamentos: ${response.body}");
    }
  }

  static Future<List<String>> buscarEncargados(String query) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await http.get(
      Uri.parse("$baseUrl/encargados?query=$query"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<String>((item) => item['nombre_encargado'].toString()).toList();
    } else {
      throw Exception("Error al buscar encargados: ${response.body}");
    }
  }
}