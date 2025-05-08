import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/providers/historial_cambios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HistorialCambiosProvider', () {
    late HistorialCambiosProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      provider = HistorialCambiosProvider();
    });

    test('initial state is empty and not loading', () {
      expect(provider.historial, isEmpty);
      expect(provider.isLoading, false);
    });

    test('loading state toggles correctly', () async {
      final future = provider.cargarHistorial();

      expect(provider.isLoading, true);

      await future;

      expect(provider.isLoading, false);
    });
  });
}