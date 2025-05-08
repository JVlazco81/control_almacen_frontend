import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/providers/historial_salidas_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HistorialSalidasProvider', () {
    late HistorialSalidasProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      provider = HistorialSalidasProvider();
    });

    test('initial state is empty and not loading', () {
      expect(provider.salidas, isEmpty);
      expect(provider.isLoading, false);
    });

    test('loading state toggles correctly', () async {
      final future = provider.cargarSalidas();

      expect(provider.isLoading, true);

      await future;

      expect(provider.isLoading, false);
    });
  });
}