import 'package:flutter/material.dart';
import '../services/entrada_service.dart';
import '../models/entrada.dart';

class EntradasProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // Notifica a la UI para que se actualicen los botones
  }

List<Map<String, String>> clavesProducto = [
  {"id": "2111", "nombre": "Materiales, útiles y equipos menores de oficina"},
  {"id": "2121", "nombre": "Materiales y útiles de impresión y reproducción"},
  {"id": "2122", "nombre": "Material fotográfico, cinematografía y grabación"},
  {"id": "2131", "nombre": "Material estadístico y geográfico"},
  {"id": "2141", "nombre": "Materiales, útiles, equipos y bienes informáticos para el procesamiento en tecnologías de la información y comunicaciones"},
  {"id": "2151", "nombre": "Material impreso e información digital"},
  {"id": "2161", "nombre": "Material de limpieza"},
  {"id": "2171", "nombre": "Materiales y útiles de enseñanza"},
  {"id": "2181", "nombre": "Materiales para el registro e identificación de bienes y personas"},
  {"id": "2211", "nombre": "Productos alimenticios para personas"},
  {"id": "2221", "nombre": "Productos alimenticios para animales"},
  {"id": "2231", "nombre": "Utensilios para el servicio de alimentación"},
  {"id": "2311", "nombre": "Productos alimenticios, agropecuarios y forestales adquiridos como materia prima"},
  {"id": "2321", "nombre": "Insumos textiles adquiridos como materia prima"},
  {"id": "2331", "nombre": "Productos de papel, cartón e impresos adquiridos como materia prima"},
  {"id": "2341", "nombre": "Combustibles, lubricantes, aditivos, carbón y sus derivados adquiridos como materia prima"},
  {"id": "2351", "nombre": "Productos químicos, farmacéuticos y de laboratorio adquiridos como materia prima"},
  {"id": "2361", "nombre": "Productos metálicos y a base de minerales no metálicos adquiridos como materia prima"},
  {"id": "2371", "nombre": "Productos de cuero, piel, plástico y hule adquiridos como materia prima"},
  {"id": "2381", "nombre": "Mercancías adquiridas para su comercialización"},
  {"id": "2391", "nombre": "Otros productos adquiridos como materia prima"},
  {"id": "2411", "nombre": "Productos minerales no metálicos"},
  {"id": "2421", "nombre": "Cemento y productos de concreto"},
  {"id": "2431", "nombre": "Cal, yeso y productos de yeso"},
  {"id": "2441", "nombre": "Madera y productos de madera"},
  {"id": "2451", "nombre": "Vidrio y productos de vidrio"},
  {"id": "2461", "nombre": "Material eléctrico y electrónico"},
  {"id": "2471", "nombre": "Artículos metálicos para la construcción"},
  {"id": "2481", "nombre": "Estructura y manufacturas"},
  {"id": "2482", "nombre": "Materiales complementarios"},
  {"id": "2491", "nombre": "Otros materiales y artículos de construcción y reparación"},
  {"id": "2511", "nombre": "Productos químicos básicos"},
  {"id": "2521", "nombre": "Fertilizantes, pesticidas y otros agroquímicos"},
  {"id": "2531", "nombre": "Medicinas y productos farmacéuticos"},
  {"id": "2541", "nombre": "Materiales, accesorios y suministros médicos"},
  {"id": "2551", "nombre": "Materiales, accesorios y suministros de laboratorio"},
  {"id": "2561", "nombre": "Fibras sintéticas, hules, plásticos y derivados"},
  {"id": "2591", "nombre": "Otros productos químicos"},
  {"id": "2611", "nombre": "Combustibles"},
  {"id": "2612", "nombre": "Lubricantes y aditivos"},
  {"id": "2621", "nombre": "Carbón y sus derivados"},
  {"id": "2711", "nombre": "Vestuario y uniformes"},
  {"id": "2721", "nombre": "Prendas de seguridad y protección personal"},
  {"id": "2731", "nombre": "Artículos deportivos"},
  {"id": "2741", "nombre": "Productos textiles"},
  {"id": "2751", "nombre": "Blancos y otros productos textiles, excepto prendas de vestir"},
  {"id": "2811", "nombre": "Sustancias y materiales explosivos"},
  {"id": "2821", "nombre": "Materiales para el señalamiento de tránsito"},
  {"id": "2822", "nombre": "Materiales de seguridad pública"},
  {"id": "2831", "nombre": "Prendas de protección para seguridad pública"},
  {"id": "2911", "nombre": "Herramientas menores"},
  {"id": "2921", "nombre": "Refacciones y accesorios menores de edificios"},
  {"id": "2931", "nombre": "Refacciones y accesorios menores de mobiliario y equipo de administración, educacional y recreativo"},
  {"id": "2941", "nombre": "Refacciones y accesorios menores de equipo de cómputo y tecnologías de la información"},
  {"id": "2951", "nombre": "Refacciones y accesorios menores de equipo e instrumental médico y de laboratorio"},
  {"id": "2961", "nombre": "Refacciones y accesorios menores de equipo de transporte"},
  {"id": "2971", "nombre": "Refacciones y accesorios menores de equipo de defensa y seguridad"},
  {"id": "2981", "nombre": "Refacciones y accesorios menores de maquinaria y otros equipos"},
  {"id": "2991", "nombre": "Refacciones y accesorios menores otros bienes muebles"},
];

  List<String> unidadesMedida = ['Caja', 'Paquete', 'Pieza'];

  void setClaveProducto(Map<String, String>? value) {
    claveProductoSeleccionada = value;
    notifyListeners();
  }

  void setUnidadMedida(String? value) {
    unidadMedidaSeleccionada = value;
    notifyListeners(); // Notifica a la UI para actualizar el select
  }

  Map<String, String>? claveProductoSeleccionada;

  // Controladores de texto
  final TextEditingController folioController = TextEditingController();
  final TextEditingController notaController = TextEditingController();

  final TextEditingController proveedorController = TextEditingController();
  final TextEditingController fechaFacturaController = TextEditingController();
  final TextEditingController fechaActualController = TextEditingController();
  final TextEditingController entradaAnualController = TextEditingController();
  final TextEditingController subtotalController = TextEditingController(
    text: "0.00",
  );
  final TextEditingController ivaController = TextEditingController(
    text: "0.00",
  );
  final TextEditingController totalController = TextEditingController(
    text: "0.00",
  );

  final TextEditingController marcaAutorController = TextEditingController();
  final TextEditingController nombreDescripcionController =
      TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController costoUnidadController = TextEditingController();
  final TextEditingController totalArticuloController = TextEditingController();

  // Variables de estado
  String? unidadMedidaSeleccionada;

  double cantidad = 0;
  double costoUnitario = 0;
  double totalArticulo = 0;
  List<Map<String, dynamic>> listaEspera = [];
  FocusNode claveProductoFocus = FocusNode();

  EntradasProvider() {
    fechaActualController.text =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    entradaAnualController.text = "#/${DateTime.now().year}";
  }

  // Método para calcular el total del artículo en el contenedor 2
  void calcularTotalArticulo() {
    totalArticulo = cantidad * costoUnitario;
    totalArticuloController.text = totalArticulo.toStringAsFixed(2);
    notifyListeners();
  }

  // Método para calcular totales generales
  void calcularTotales() {
    double subtotal = listaEspera.fold(
      0,
      (sum, item) => sum + (double.tryParse(item["total"] ?? "0") ?? 0),
    );
    double iva = subtotal * 0.16;
    double total = subtotal + iva;

    subtotalController.text = subtotal.toStringAsFixed(2);
    ivaController.text = iva.toStringAsFixed(2);
    totalController.text = total.toStringAsFixed(2);
    notifyListeners();
  }

  // Validación de campos en el contenedor 2
  bool validarCampos() {
    return nombreDescripcionController.text.isNotEmpty &&
        claveProductoSeleccionada != null &&
        unidadMedidaSeleccionada != null &&
        cantidadController.text.isNotEmpty &&
        costoUnidadController.text.isNotEmpty;
  }

  // Validación de los campos generales (Proveedor y Fecha de Factura)
  bool validarCamposGenerales() {
    return proveedorController.text.isNotEmpty &&
        fechaFacturaController.text.isNotEmpty &&
        entradaAnualController.text.isNotEmpty &&
        folioController.text.isNotEmpty &&
        notaController.text.isNotEmpty;
  }

  // Agregar artículo a la lista de espera
  void agregarProducto() {
    if (validarCampos()) {
      listaEspera.add({
        "claveProducto": claveProductoSeleccionada?["id"].toString(),
        "descripcion": nombreDescripcionController.text,
        "marcaAutor": marcaAutorController.text,
        "unidad": unidadMedidaSeleccionada.toString(),
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

    claveProductoSeleccionada = clavesProducto.firstWhere(
      (item) => item["id"] == articulo["claveProducto"],
      orElse: () => {"id": "", "nombre": ""},
    );
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
    folioController.clear();
    notaController.clear();
    entradaAnualController.text = "#/${DateTime.now().year}";
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

  Future<Map<String, dynamic>> subirInventario() async {
    _isLoading = true;
    notifyListeners();

    Entrada entrada = Entrada(
      proveedor: proveedorController.text,
      fechaFactura: fechaFacturaController.text,
      folio: folioController.text,
      nota: notaController.text,
      productos: List<Map<String, dynamic>>.from(listaEspera),
    );

    // Imprimir el JSON que se enviará al backend
    String jsonEntrada = entrada.toJsonString();

    final result = await EntradaService.subirInventario(jsonEntrada);

    if (result["success"] == true && result.containsKey("id_entrada")) {
      try {
        int idEntrada = result["id_entrada"];
        await EntradaService.descargarPDFEntrada(idEntrada);
      } catch (e) {
        debugPrint("❌ Error al descargar PDF: $e");
      }
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }
}
