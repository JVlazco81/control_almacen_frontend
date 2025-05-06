// lib/models/entrada_historial.dart

class ProductoEntrada {
  final int idProducto;
  final int codigo;
  final String descripcion;
  final String? marca;
  final int cantidad;
  final String unidad;
  final String categoria;
  final double precio;

  ProductoEntrada({
    required this.idProducto,
    required this.codigo,
    required this.descripcion,
    this.marca,
    required this.cantidad,
    required this.unidad,
    required this.categoria,
    required this.precio,
  });

  factory ProductoEntrada.fromJson(Map<String, dynamic> json) {
    return ProductoEntrada(
      idProducto: json['id_producto'],
      codigo: json['codigo'],
      descripcion: json['descripcion'],
      marca: json['marca'],
      cantidad: json['cantidad'],
      unidad: json['unidad'],
      categoria: json['categoria'],
      precio: double.parse(json['precio'].toString()),
    );
  }
}

class EntradaHistorial {
  final int id;
  final String folio;
  final int entradaAnual;
  final String proveedor;
  final String fechaFactura;
  final String fechaEntrada;
  final String? nota;
  final List<ProductoEntrada> productos;

  EntradaHistorial({
    required this.id,
    required this.folio,
    required this.entradaAnual,
    required this.proveedor,
    required this.fechaFactura,
    required this.fechaEntrada,
    this.nota,
    required this.productos,
  });

  factory EntradaHistorial.fromJson(Map<String, dynamic> json) {
    List<dynamic> productosJson = json['productos'] ?? [];
    return EntradaHistorial(
      id: json['id_entrada'],
      folio: json['folio'],
      entradaAnual: json['entrada_anual'],
      proveedor: json['proveedor'],
      fechaFactura: json['fecha_factura'],
      fechaEntrada: json['fecha_entrada'],
      nota: json['nota'],
      productos: productosJson
          .map((e) => ProductoEntrada.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
