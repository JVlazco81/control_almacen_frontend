import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/models/user.dart';

void main() {
  group('User Model', () {
    test('fromJson and toJsonLogin work correctly', () {
      final json = {
        'id_usuario': 1,
        'id_rol': 2,
        'primer_nombre': 'Luis',
        'segundo_nombre': 'Andrés',
        'primer_apellido': 'Pérez',
        'segundo_apellido': 'Martínez',
      };

      final user = User.fromJson(json);
      final loginJson = user.toJsonLogin('pass123');

      expect(user.primerNombre, 'Luis');
      expect(loginJson['usuario_password'], 'pass123');
    });
  });
}
