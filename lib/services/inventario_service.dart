import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/producto.dart';
import '../core/api.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class InventarioService {
  static Future<List<Producto>> obtenerInventario({
    http.Client? client,
    String? baseUrl,
  }) async {
    client ??= http.Client();
    baseUrl ??= await ApiConfig.getBaseUrl();

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await client.get(
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

  static Future<void> descargarReporteInventario() async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final url = Uri.parse("$baseUrl/inventario/reporte?pdf=true");
    final response = await http.get(url, headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      final fileName = "reporte_inventario.pdf";
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
      throw Exception("Error al descargar el PDF del inventario: ${response.statusCode}");
    }
  }
}
