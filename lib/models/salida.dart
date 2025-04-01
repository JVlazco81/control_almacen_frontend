import 'dart:convert';

class Salida {
  String departamento;
  String encargado;
  String ordenCompra;
  List<Map<String, dynamic>> productos;

  Salida({
    required this.departamento,
    required this.encargado,
    required this.ordenCompra,
    required this.productos,
  });

  Map<String, dynamic> toJson() {
    return {
      "departamento": departamento,
      "encargado": encargado,
      "ordenCompra": ordenCompra,
      "productos": productos,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}