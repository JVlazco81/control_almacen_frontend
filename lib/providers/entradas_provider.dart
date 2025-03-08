import 'package:flutter/material.dart';

class EntradasProvider extends ChangeNotifier {
  List<String> clavesProducto = [
    'Clasificación 1',
    'Clasificación 2',
    'Clasificación 3',
    'Clasificación Especial',
    'Otra Clasificación',
  ];

  List<String> unidadesMedida = ['PZA', 'CAJA', 'PAQUETE'];
  
  // Controladores de texto
  final TextEditingController proveedorController = TextEditingController();
  final TextEditingController fechaFacturaController = TextEditingController();
  final TextEditingController fechaActualController = TextEditingController();
  final TextEditingController entradaAnualController = TextEditingController();
  final TextEditingController subtotalController = TextEditingController(text: "0.00");
  final TextEditingController ivaController = TextEditingController(text: "0.00");
  final TextEditingController totalController = TextEditingController(text: "0.00");

  final TextEditingController marcaAutorController = TextEditingController();
  final TextEditingController nombreDescripcionController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController costoUnidadController = TextEditingController();
  final TextEditingController totalArticuloController = TextEditingController();

  // Variables de estado
  String? claveProductoSeleccionada;
  String? unidadMedidaSeleccionada;
  double cantidad = 0;
  double costoUnitario = 0;
  double totalArticulo = 0;
  List<Map<String, dynamic>> listaEspera = [];
  FocusNode claveProductoFocus = FocusNode();

  EntradasProvider() {
    fechaActualController.text =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    entradaAnualController.text = "4/${DateTime.now().year}";
  }

  // Método para calcular el total del artículo en el contenedor 2
  void calcularTotalArticulo() {
    totalArticulo = cantidad * costoUnitario;
    totalArticuloController.text = totalArticulo.toStringAsFixed(2);
    notifyListeners();
  }

  // Método para calcular totales generales
  void calcularTotales() {
    double subtotal = listaEspera.fold(0, (sum, item) => sum + (double.tryParse(item["total"] ?? "0") ?? 0));
    double iva = subtotal * 0.16;
    double total = subtotal + iva;

    subtotalController.text = subtotal.toStringAsFixed(2);
    ivaController.text = iva.toStringAsFixed(2);
    totalController.text = total.toStringAsFixed(2);
    notifyListeners();
  }

  // Validación de campos en el contenedor 2
  bool validarCampos() {
    return marcaAutorController.text.isNotEmpty &&
           nombreDescripcionController.text.isNotEmpty &&
           claveProductoSeleccionada != null &&
           unidadMedidaSeleccionada != null &&
           cantidadController.text.isNotEmpty &&
           costoUnidadController.text.isNotEmpty;
  }

  // Validación de los campos generales (Proveedor y Fecha de Factura)
  bool validarCamposGenerales() {
    return proveedorController.text.isNotEmpty && fechaFacturaController.text.isNotEmpty;
  }

  // Agregar artículo a la lista de espera
  void agregarArticulo() {
    if (validarCampos()) {
      listaEspera.add({
        "clasificacion": claveProductoSeleccionada ?? '',
        "descripcion": nombreDescripcionController.text,
        "marcaAutor": marcaAutorController.text,
        "unidad": unidadMedidaSeleccionada ?? '',
        "cantidad": cantidadController.text,
        "costo": costoUnidadController.text,
        "total": totalArticulo.toStringAsFixed(2),
      });

      limpiarCamposProducto();
      calcularTotales();
      notifyListeners();
    }
  }

  // Eliminar un artículo de la lista de espera
  void eliminarArticulo(int index) {
    listaEspera.removeAt(index);
    calcularTotales();
    notifyListeners();
  }

  // Editar un artículo de la lista de espera
  void editarArticulo(int index) {
    Map<String, dynamic> articulo = listaEspera[index];

    claveProductoSeleccionada = articulo["clasificacion"];
    nombreDescripcionController.text = articulo["descripcion"];
    marcaAutorController.text = articulo["marcaAutor"];
    unidadMedidaSeleccionada = articulo["unidad"];
    cantidadController.text = articulo["cantidad"];
    costoUnidadController.text = articulo["costo"];
    totalArticuloController.text = articulo["total"];

    cantidad = double.tryParse(articulo["cantidad"] ?? "0") ?? 0;
    costoUnitario = double.tryParse(articulo["costo"] ?? "0") ?? 0;
    totalArticulo = cantidad * costoUnitario;

    listaEspera.removeAt(index);
    calcularTotales();
    notifyListeners();
  }

  // Reiniciar formulario completo
  void reiniciarFormulario() {
    proveedorController.clear();
    fechaFacturaController.clear();
    limpiarCamposProducto();
    listaEspera.clear();
    calcularTotales();
    notifyListeners();
  }

  // Limpiar solo los campos del contenedor 2 (productos)
  void limpiarCamposProducto() {
    marcaAutorController.clear();
    nombreDescripcionController.clear();
    claveProductoSeleccionada = null;
    unidadMedidaSeleccionada = null;
    cantidadController.clear();
    costoUnidadController.clear();
    totalArticulo = 0;
    totalArticuloController.text = "0.00";
    notifyListeners();
  }

  void setClaveProducto(String? value) {
    claveProductoSeleccionada = value;
    notifyListeners(); // Notifica a la UI para actualizar el select
  }

  void setUnidadMedida(String? value) {
    unidadMedidaSeleccionada = value;
    notifyListeners(); // Notifica a la UI para actualizar el select
  }
}