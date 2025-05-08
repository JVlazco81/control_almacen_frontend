import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entrada_historial.dart';
import '../core/api.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class HistorialEntradasService {
  static Future<List<EntradaHistorial>> obtenerEntradas({
    http.Client? client,
    String? baseUrl,
  }) async {
    client ??= http.Client();
    baseUrl ??= await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await client.get(
      Uri.parse("$baseUrl/entradas"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => EntradaHistorial.fromJson(item)).toList();
    } else {
      throw Exception("Error al obtener el historial de entradas: ${response.body}");
    }
  }

  static Future<void> eliminarEntrada(int idEntrada) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await http.delete(
      Uri.parse("$baseUrl/entradas/$idEntrada"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar la entrada: ${response.body}");
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