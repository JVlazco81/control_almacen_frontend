import 'dart:convert';

class Entrada {
  String proveedor;
  String fechaFactura;
  String folio;
  String nota;
  List<Map<String, dynamic>> productos;

  Entrada({
    required this.proveedor,
    required this.fechaFactura,
    required this.folio,
    required this.nota,
    required this.productos,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      "proveedor": proveedor,
      "fechaFactura": fechaFactura,
      "folio": folio,
      "nota": nota,
      "productos": productos,
    };
  }

  // Convertir a String JSON
  String toJsonString() {
    return jsonEncode(toJson());
  }
}