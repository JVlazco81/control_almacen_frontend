import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/inventario_service.dart';

class InventarioProvider extends ChangeNotifier {
  List<Producto> _inventario = [];
  bool _isLoading = false;

  List<Producto> get inventario => _inventario;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> cargarInventario() async {
    setLoading(true);
    try {
      _inventario = await InventarioService.obtenerInventario();
    } catch (e) {
      print("❌ Error al cargar el inventario: $e");
    }
    setLoading(false);
  }
}
