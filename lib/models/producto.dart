class Producto {
  final int num;
  final int claveProducto;
  final String descripcion;
  final String? marcaAutor;
  final String categoria;
  final String unidad;
  final int existencias;
  final double costoPorUnidad;
  final double subtotal;
  final double iva;
  final double montoTotal;

  Producto({
    required this.num,
    required this.claveProducto,
    required this.descripcion,
    this.marcaAutor,
    required this.categoria,
    required this.unidad,
    required this.existencias,
    required this.costoPorUnidad,
    required this.subtotal,
    required this.iva,
    required this.montoTotal,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      num: json["num"],
      claveProducto: json["clave_producto"],
      descripcion: json["descripcion"],
      marcaAutor: json["marca_autor"],
      categoria: json["categoria"],
      unidad: json["unidad"],
      existencias: json["existencias"],
      costoPorUnidad: double.parse(json["costo_por_unidad"].replaceAll(",", "")),
      subtotal: double.parse(json["subtotal"].replaceAll(",", "")),
      iva: double.parse(json["iva"].replaceAll(",", "")),
      montoTotal: double.parse(json["monto_total"].replaceAll(",", "")),
    );
  }
}
