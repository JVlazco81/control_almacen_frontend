import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/providers/entradas_provider.dart';

void main() {
  group('EntradasProvider', () {
    late EntradasProvider provider;

    setUp(() {
      provider = EntradasProvider();
    });

    test('setLoading actualiza isLoading', () {
      provider.setLoading(true);
      expect(provider.isLoading, true);

      provider.setLoading(false);
      expect(provider.isLoading, false);
    });

    test('calcularTotalArticulo calcula correctamente', () {
      provider.cantidad = 2;
      provider.costoUnitario = 50;
      provider.calcularTotalArticulo();
      expect(provider.totalArticulo, 100);
      expect(provider.totalArticuloController.text, '100.00');
    });

    test('agregarProducto agrega artículo cuando campos son válidos', () {
      provider.nombreDescripcionController.text = 'Prueba';
      provider.claveProductoSeleccionada = {'id': '123', 'nombre': 'Producto'};
      provider.unidadMedidaSeleccionada = 'Caja';
      provider.cantidadController.text = '2';
      provider.costoUnidadController.text = '10';
      provider.totalArticulo = 20;

      provider.agregarProducto();
      expect(provider.listaEspera.length, 1);
      expect(provider.listaEspera.first['descripcion'], 'Prueba');
    });

    test('eliminarArticulo remueve artículo', () {
      provider.listaEspera.add({'id': 1, 'descripcion': 'Test'});
      provider.eliminarArticulo(0);
      expect(provider.listaEspera.isEmpty, true);
    });

    test('limpiarCamposProducto resetea campos', () {
      provider.nombreDescripcionController.text = 'Test';
      provider.totalArticulo = 50;
      provider.limpiarCamposProducto();
      expect(provider.nombreDescripcionController.text, '');
      expect(provider.totalArticulo, 0);
    });

    test('reiniciarFormulario limpia todo', () {
      provider.proveedorController.text = 'Proveedor';
      provider.listaEspera.add({'id': 1});
      provider.reiniciarFormulario();
      expect(provider.proveedorController.text, '');
      expect(provider.listaEspera.isEmpty, true);
    });
  });
}