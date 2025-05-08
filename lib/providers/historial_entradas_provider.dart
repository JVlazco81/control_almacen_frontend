import 'package:flutter/material.dart';

import '../models/entrada_historial.dart';
import '../services/historial_entrada_service.dart';

class HistorialEntradasProvider extends ChangeNotifier {
  List<EntradaHistorial> _entradas = [];
  bool _isLoading = false;

  List<EntradaHistorial> get entradas => _entradas;
  bool get isLoading => _isLoading;

  Future<void> cargarEntradas() async {
    _isLoading = true;
    notifyListeners();

    try {
      _entradas = await HistorialEntradasService.obtenerEntradas();
    } catch (e) {
      _entradas = [];
      debugPrint("❌ Error al cargar entradas: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}