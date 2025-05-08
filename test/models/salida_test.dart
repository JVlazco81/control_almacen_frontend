import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/models/salida.dart';

void main() {
  group('Salida Model', () {
    test('toJson returns correct map', () {
      final salida = Salida(
        departamento: 'DeptoX',
        encargado: 'EncargadoX',
        ordenCompra: 'OC123',
        productos: [],
      );

      final json = salida.toJson();
      expect(json['departamento'], 'DeptoX');
      expect(json['ordenCompra'], 'OC123');
    });
  });
}