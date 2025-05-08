import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/providers/historial_entradas_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HistorialEntradasProvider', () {
    late HistorialEntradasProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      provider = HistorialEntradasProvider();
    });

    test('initial state is empty and not loading', () {
      expect(provider.entradas, isEmpty);
      expect(provider.isLoading, false);
    });

    test('loading state toggles correctly', () async {
      final future = provider.cargarEntradas();

      expect(provider.isLoading, true);

      await future;

      expect(provider.isLoading, false);
    });
  });
}