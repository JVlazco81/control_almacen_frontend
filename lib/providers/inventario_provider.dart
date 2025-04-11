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

  Future<void> actualizarProducto(int id, Map<String, dynamic> data) async {
    try {
      await InventarioService.actualizarProducto(id, data);
      print("✅ Producto actualizado correctamente.");
    } catch (e) {
      print("❌ Error al actualizar el producto: $e");
      rethrow;
    }
  }

  Future<void> eliminarProducto(int id) async {
    try {
      await InventarioService.eliminarProducto(id);
      print("🗑️ Producto eliminado correctamente.");
    } catch (e) {
      print("❌ Error al eliminar producto: $e");
      rethrow;
    }
  }

  Future<void> generarReporteInventario() async {
    try {
      await InventarioService.descargarReporteInventario();
    } catch (e) {
      print("❌ Error al descargar PDF del inventario: $e");
    }
  }
}
