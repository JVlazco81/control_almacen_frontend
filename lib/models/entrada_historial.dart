// lib/models/entrada_historial.dart

class EntradaHistorial {
  final int id;
  final String folio;
  final int entradaAnual;
  final String proveedor;
  final String fechaFactura;
  final String fechaEntrada;
  final String? nota;

  EntradaHistorial({
    required this.id,
    required this.folio,
    required this.entradaAnual,
    required this.proveedor,
    required this.fechaFactura,
    required this.fechaEntrada,
    this.nota,
  });

  factory EntradaHistorial.fromJson(Map<String, dynamic> json) {
    return EntradaHistorial(
      id: json['id_entrada'],
      folio: json['folio'],
      entradaAnual: json['entrada_anual'],
      proveedor: json['proveedor'],
      fechaFactura: json['fecha_factura'],
      fechaEntrada: json['fecha_entrada'],
      nota: json['nota'],
    );
  }
}
