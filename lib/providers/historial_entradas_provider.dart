import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/entrada_historial.dart';
import '../services/auth_service.dart';

class HistorialEntradasProvider extends ChangeNotifier {
  List<EntradaHistorial> _entradas = [];
  bool _isLoading = false;

  List<EntradaHistorial> get entradas => _entradas;
  bool get isLoading => _isLoading;

  Future<void> cargarEntradas() async {
    _isLoading = true;
    notifyListeners();

    final token = await AuthService.getToken();
    final url = Uri.parse('http://192.168.0.21:80/api/historial-entradas');

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
        _entradas =
            data
                .map(
                  (e) => EntradaHistorial.fromJson(e as Map<String, dynamic>),
                )
                .toList();
      } else {
        _entradas = [];
        debugPrint("❌ Error backend: ${response.statusCode}");
      }
    } catch (e) {
      _entradas = [];
      debugPrint("❌ Error conexión: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
