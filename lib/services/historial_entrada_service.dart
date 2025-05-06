import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entrada_historial.dart';
import '../core/api.dart';
import 'package:url_launcher/url_launcher.dart';

class HistorialEntradasService {
  static Future<List<EntradaHistorial>> obtenerEntradas() async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");

    final response = await http.get(
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

  static Future<void> abrirPDF(int idEntrada) async {
    String baseUrl = await ApiConfig.getBaseUrl();
    final pdfUrl = Uri.parse("$baseUrl/entradas/vales/$idEntrada?pdf=true");

    if (await canLaunchUrl(pdfUrl)) {
      await launchUrl(pdfUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception("No se pudo abrir el PDF");
    }
  }
}