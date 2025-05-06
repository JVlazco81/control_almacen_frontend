class ProductoSalida {
  final int idProducto;
  final int codigo;
  final String descripcion;
  final String? marca;
  final int cantidad;
  final String unidad;
  final String categoria;
  final double precio;

  ProductoSalida({
    required this.idProducto,
    required this.codigo,
    required this.descripcion,
    this.marca,
    required this.cantidad,
    required this.unidad,
    required this.categoria,
    required this.precio,
  });

  factory ProductoSalida.fromJson(Map<String, dynamic> json) {
    return ProductoSalida(
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

class SalidaHistorial {
  final int id;
  final String departamento;
  final String folio;
  final int salidaAnual;
  final String fechaSalida;
  final int ordenCompra;
  final List<ProductoSalida> productos;

  SalidaHistorial({
    required this.id,
    required this.departamento,
    required this.folio,
    required this.salidaAnual,
    required this.fechaSalida,
    required this.ordenCompra,
    required this.productos,
  });

  factory SalidaHistorial.fromJson(Map<String, dynamic> json) {
    List<dynamic> productosJson = json['productos'] ?? [];
    return SalidaHistorial(
      id: json['id_salida'],
      departamento: json['departamento'],
      folio: json['folio'],
      salidaAnual: json['salida_anual'],
      fechaSalida: json['fecha_salida'],
      ordenCompra: json['orden_compra'],
      productos: productosJson
          .map((e) => ProductoSalida.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}