import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/models/salida_historial.dart';

void main() {
  group('SalidaHistorial Model', () {
    test('fromJson creates correct object', () {
      final json = {
        'id_salida': 1,
        'departamento': 'DeptoA',
        'folio': 'S123',
        'salida_anual': 2024,
        'fecha_salida': '2024-05-08',
        'orden_compra': 5678,
        'productos': [
          {
            'id_producto': 10,
            'codigo': 2001,
            'descripcion': 'Producto B',
            'marca': 'MarcaB',
            'cantidad': 2,
            'unidad': 'Pieza',
            'categoria': 'CatB',
            'precio': 200.0,
          }
        ],
      };

      final salidaHistorial = SalidaHistorial.fromJson(json);
      expect(salidaHistorial.departamento, 'DeptoA');
      expect(salidaHistorial.productos.first.descripcion, 'Producto B');
    });
  });
}