import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../../providers/salidas_provider.dart';
import '../producto_selector_dialog.dart';

class FormProductosSalida extends StatelessWidget {
  const FormProductosSalida({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SalidasProvider>(context);

    void mostrarDialogoVaciarFormulario(BuildContext context, SalidasProvider provider) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmación"),
            content: Text("Estás a punto de vaciar el formulario. ¿Deseas continuar?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () {
                  provider.limpiarCamposProducto();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Vaciar", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    }

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
            'Agregar productos a la salida',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: provider.folioController,
                  decoration: InputDecoration(labelText: 'Folio'),
                ),
              ),
              SizedBox(width: 10),
Expanded(
  child: TextField(
    controller: provider.descripcionController,
    decoration: InputDecoration(
      labelText: 'Descripción',
      suffixIcon: IconButton(
        icon: Icon(Icons.search),
        onPressed: () async {
          final seleccionado = await showDialog<String>(
            context: context,
            builder: (context) => ProductoSelectorDialog(),
          );
          if (seleccionado != null) {
            provider.descripcionController.text = seleccionado;
          }
        },
      ),
    ),
  ),
),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: provider.cantidadController,
                  decoration: InputDecoration(labelText: 'Cantidad'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            alignment: WrapAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (!provider.validarCamposProducto()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Por favor, completa todos los campos"),
                      backgroundColor: Colors.red,
                    ));
                    return;
                  }

                  provider.agregarProducto();
                },
                child: Text('Agregar a espera'),
              ),
              ElevatedButton(
                onPressed: () => mostrarDialogoVaciarFormulario(context, provider),
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
