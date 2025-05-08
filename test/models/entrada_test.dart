import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/models/entrada.dart';

void main() {
  group('Entrada Model', () {
    test('toJson returns correct map', () {
      final entrada = Entrada(
        proveedor: 'Proveedor1',
        fechaFactura: '2024-05-08',
        folio: 'F123',
        nota: 'Nota prueba',
        productos: [],
      );

      final json = entrada.toJson();

      expect(json['proveedor'], 'Proveedor1');
      expect(json['fechaFactura'], '2024-05-08');
      expect(json['folio'], 'F123');
      expect(json['nota'], 'Nota prueba');
      expect(json['productos'], isEmpty);
    });
  });
}