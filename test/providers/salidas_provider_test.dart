import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/providers/salidas_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SalidasProvider', () {
    late SalidasProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      provider = SalidasProvider();
    });

    test('initial state is not loading and listaEspera is empty', () {
      expect(provider.isLoading, false);
      expect(provider.listaEspera, isEmpty);
    });

    test('agregarProducto adds product when fields are valid', () {
      provider.folioController.text = 'F123';
      provider.descripcionController.text = 'Producto A';
      provider.cantidadController.text = '3';

      provider.agregarProducto();

      expect(provider.listaEspera.length, 1);
      expect(provider.listaEspera.first['folio'], 'F123');
    });

    test('eliminarArticulo removes product', () {
      provider.listaEspera.add({'folio': 'F123'});
      provider.eliminarArticulo(0);
      expect(provider.listaEspera, isEmpty);
    });

    test('reiniciarFormulario clears data', () {
      provider.departamentoController.text = 'Depto';
      provider.listaEspera.add({'folio': 'F123'});

      provider.reiniciarFormulario();

      expect(provider.departamentoController.text, '');
      expect(provider.listaEspera, isEmpty);
    });

    test('calcularTotalArticulos sums quantities correctly', () {
      provider.listaEspera = [
        {'cantidad': 2},
        {'cantidad': 3},
      ];
      expect(provider.calcularTotalArticulos(), 5);
    });
  });
}