import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/providers/inventario_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InventarioProvider', () {
    late InventarioProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      provider = InventarioProvider();
    });

    test('initial state is empty and not loading', () {
      expect(provider.inventario, isEmpty);
      expect(provider.isLoading, false);
    });

    test('setLoading updates isLoading', () {
      provider.setLoading(true);
      expect(provider.isLoading, true);

      provider.setLoading(false);
      expect(provider.isLoading, false);
    });
  });
}