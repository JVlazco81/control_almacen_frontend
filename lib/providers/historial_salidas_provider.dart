import 'package:flutter/material.dart';
import '../models/salida_historial.dart';
import '../services/historial_salidas_service.dart';

class HistorialSalidasProvider extends ChangeNotifier {
  List<SalidaHistorial> _salidas = [];
  bool _isLoading = false;

  List<SalidaHistorial> get salidas => _salidas;
  bool get isLoading => _isLoading;

  Future<void> cargarSalidas() async {
    _isLoading = true;
    notifyListeners();

    try {
      _salidas = await HistorialSalidasService.obtenerSalidas();
    } catch (e) {
      _salidas = [];
      debugPrint("❌ Error al cargar salidas: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}