import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UsuariosProvider', () {
    late UsuariosProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      provider = UsuariosProvider();
    });

    test('initial state is empty and not loading', () {
      expect(provider.usuarios, isEmpty);
      expect(provider.isLoading, false);
    });

    test('cargarUsuarios sets loading state', () async {
      final future = provider.cargarUsuarios();

      expect(provider.isLoading, true);
      await future;
      expect(provider.isLoading, false);
    });
  });
}