import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/models/producto.dart';

void main() {
  group('Producto Model', () {
    test('fromJson parses correctly', () {
      final json = {
        'num': 1,
        'clave_producto': 1001,
        'descripcion': 'Producto A',
        'marca_autor': 'MarcaX',
        'categoria': 'CatA',
        'unidad': 'Caja',
        'existencias': 10,
        'costo_por_unidad': '100.0',
        'subtotal': '1000.0',
        'iva': '160.0',
        'monto_total': '1160.0',
      };

      final producto = Producto.fromJson(json);
      expect(producto.descripcion, 'Producto A');
      expect(producto.costoPorUnidad, 100.0);
    });
  });
}