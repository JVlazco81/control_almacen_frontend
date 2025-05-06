import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/salida_historial.dart';
import '../core/api.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class HistorialSalidasService {
  static Future<List<SalidaHistorial>> obtenerSalidas() async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await http.get(
      Uri.parse("$baseUrl/salidas"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => SalidaHistorial.fromJson(item)).toList();
    } else {
      throw Exception("Error al obtener el historial de salidas: ${response.body}");
    }
  }

  static Future<void> eliminarSalida(int idSalida) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await http.delete(
      Uri.parse("$baseUrl/salidas/$idSalida"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar la salida: ${response.body}");
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
}