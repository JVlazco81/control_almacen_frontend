import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/models/historial_cambio.dart';

void main() {
  group('HistorialCambio Model', () {
    test('fromJson creates correct object', () {
      final json = {
        'accion': 'update',
        'usuario': {
          'primer_nombre': 'Juan',
          'segundo_nombre': 'Pablo',
          'primer_apellido': 'Gómez',
          'segundo_apellido': 'López'
        },
        'fecha': '2024-05-08',
        'valor_anterior': '{"campo":"valor"}',
        'valor_nuevo': '{"campo":"nuevo"}',
      };

      final cambio = HistorialCambio.fromJson(json);
      expect(cambio.usuario, contains('Juan'));
      expect(cambio.valorAnterior?['campo'], 'valor');
      expect(cambio.valorNuevo?['campo'], 'nuevo');
    });
  });
}