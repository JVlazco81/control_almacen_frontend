import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/models/entrada_historial.dart';

void main() {
  group('EntradaHistorial Model', () {
    test('fromJson creates correct object', () {
      final json = {
        'id_entrada': 1,
        'folio': 'F123',
        'entrada_anual': 2024,
        'proveedor': 'ProveedorX',
        'fecha_factura': '2024-05-08',
        'fecha_entrada': '2024-05-08',
        'nota': 'Nota test',
        'productos': [
          {
            'id_producto': 10,
            'codigo': 1001,
            'descripcion': 'Producto A',
            'marca': 'MarcaA',
            'cantidad': 5,
            'unidad': 'Caja',
            'categoria': 'Cat1',
            'precio': 100.0,
          }
        ],
      };

      final historial = EntradaHistorial.fromJson(json);
      expect(historial.id, 1);
      expect(historial.productos.first.descripcion, 'Producto A');
    });
  });
}