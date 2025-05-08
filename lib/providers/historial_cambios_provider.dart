import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/historial_cambio.dart';
import '../services/auth_service.dart'; // debe existir getToken()

class HistorialCambiosProvider with ChangeNotifier {
  List<HistorialCambio> _historial = [];
  bool isLoading = false;

  List<HistorialCambio> get historial => _historial;

  Future<void> cargarHistorial() async {
    isLoading = true;
    notifyListeners();

    final token = await AuthService.getToken();
    final url = Uri.parse('http://localhost:80/api/historial-cambios');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _historial =
            data.map((item) => HistorialCambio.fromJson(item)).toList();
      } else {
        debugPrint("❌ Error de backend: ${response.statusCode}");
        _historial = [];
      }
    } catch (e) {
      debugPrint("❌ Error de conexión: $e");
      _historial = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
