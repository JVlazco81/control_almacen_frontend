import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';
import '../../providers/entradas_provider.dart';

class FormProductos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EntradasProvider>(context);

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información productos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownSearch<String>(
                  items: provider.clavesProducto,
                  selectedItem: provider.claveProductoSeleccionada,
                  popupProps: PopupProps.menu(showSearchBox: true),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: 'Clave del producto',
                    ),
                  ),
                  onChanged: provider.setClaveProducto,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: provider.nombreDescripcionController,
                  decoration: InputDecoration(labelText: 'Nombre/Descripción'),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: provider.marcaAutorController,
                  decoration: InputDecoration(labelText: 'Marca o Autor'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: provider.unidadMedidaSeleccionada,
                  items: provider.unidadesMedida
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Unidad de medida'),
                  onChanged: provider.setUnidadMedida,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: provider.cantidadController,
                  decoration: InputDecoration(labelText: 'Cantidad'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    provider.cantidad = double.tryParse(value) ?? 0;
                    provider.calcularTotalArticulo();
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: provider.costoUnidadController,
                  decoration: InputDecoration(labelText: 'Costo por unidad'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  onChanged: (value) {
                    provider.costoUnitario = double.tryParse(value) ?? 0;
                    provider.calcularTotalArticulo();
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: provider.totalArticuloController,
                  decoration: InputDecoration(
                    labelText: 'Total (productos)',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.grey[300],
                    enabled: false,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10, // Espaciado horizontal entre botones
            runSpacing: 10, // Espaciado vertical cuando se acomodan en otra línea
            alignment: WrapAlignment.end, // Alineación a la derecha
            children: [
              ElevatedButton(
                onPressed: () {
                  if (!provider.validarCampos()) {
                    // Mostrar alerta si falta algún campo
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Por favor, complete todos los campos."),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // agregar a lista de espera si pasa la validación
                  provider.agregarArticulo();
                },
                child: Text('Agregar a espera'),
              ),

              ElevatedButton(
                onPressed: provider.limpiarCamposProducto,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Vaciar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}