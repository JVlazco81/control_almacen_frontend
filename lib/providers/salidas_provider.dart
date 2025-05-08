import 'package:flutter/material.dart';
import '../models/salida.dart';
import '../services/salida_service.dart';

class SalidasProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Controladores generales
  final TextEditingController departamentoController = TextEditingController();
  final TextEditingController encargadoController = TextEditingController();
  final TextEditingController ordenCompraController = TextEditingController();
  final TextEditingController fechaActualController = TextEditingController();
  final TextEditingController salidaAnualController = TextEditingController();

  // Controladores productos
  final TextEditingController folioController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();

  List<Map<String, dynamic>> listaEspera = [];

  SalidasProvider() {
    fechaActualController.text =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    salidaAnualController.text = "#/${DateTime.now().year}";
  }

  bool validarCamposGenerales() {
    return departamentoController.text.isNotEmpty &&
        encargadoController.text.isNotEmpty &&
        ordenCompraController.text.isNotEmpty &&
        salidaAnualController.text.isEmpty;
  }

  bool validarCamposProducto() {
    return folioController.text.isNotEmpty &&
        descripcionController.text.isNotEmpty &&
        cantidadController.text.isNotEmpty;
  }

  void agregarProducto() {
    if (!validarCamposProducto()) return;

    listaEspera.add({
      "folio": folioController.text,
      "descripcion": descripcionController.text,
      "cantidad": int.tryParse(cantidadController.text) ?? 0,
    });

    limpiarCamposProducto();
    notifyListeners();
  }

  void editarArticulo(int index) {
    final producto = listaEspera[index];

    folioController.text = producto["folio"].toString();
    descripcionController.text = producto["descripcion"].toString();
    cantidadController.text = producto["cantidad"].toString();

    listaEspera.removeAt(index);
    notifyListeners();
  }

  void eliminarArticulo(int index) {
    listaEspera.removeAt(index);
    notifyListeners();
  }

  void limpiarCamposProducto() {
    folioController.clear();
    descripcionController.clear();
    cantidadController.clear();
    notifyListeners();
  }

  void reiniciarFormulario() {
    departamentoController.clear();
    encargadoController.clear();
    ordenCompraController.clear();
    limpiarCamposProducto();
    listaEspera.clear();
    notifyListeners();
    salidaAnualController.text = "#/${DateTime.now().year}";
  }

  int calcularTotalArticulos() {
    return listaEspera.fold(
      0, //valor inicial de prev
      (prev, item) => prev + (int.tryParse(item['cantidad'].toString()) ?? 0),
    );
  }

  Future<Map<String, dynamic>> enviarSalida() async {
    _isLoading = true;
    notifyListeners();

    final salida = Salida(
      departamento: departamentoController.text,
      encargado: encargadoController.text,
      ordenCompra: ordenCompraController.text,
      productos: listaEspera,
    );

    final jsonSalida = salida.toJsonString();

    final result = await SalidaService.registrarSalida(jsonSalida);

    if (result["success"] == true && result.containsKey("id_salida")) {
      try {
        int idSalida = result["id_salida"];
        await SalidaService.descargarPDFSalida(idSalida);
      } catch (e) {
        print("❌ Error al descargar PDF de salida: $e");
      }
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }
}
