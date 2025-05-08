import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/entradas_provider.dart';
import '../../widgets/proveedor_selector_dialog.dart';

class FormularioInformacion extends StatelessWidget {
  const FormularioInformacion({super.key});

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
            'Información general',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: provider.proveedorController,
                  decoration: InputDecoration(
                    labelText: 'Proveedor',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        final seleccionado = await showDialog<String>(
                          context: context,
                          builder: (context) => ProveedorSelectorDialog(),
                        );
                        if (seleccionado != null) {
                          provider.proveedorController.text = seleccionado;
                        }
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: provider.fechaFacturaController,
                  decoration: InputDecoration(labelText: 'Fecha de la factura'),
                  readOnly: true,
                  onTap: () => showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      provider.fechaFacturaController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    }
                  }),
                ),
              ),
            ],
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
                  controller: provider.notaController,
                  decoration: InputDecoration(labelText: 'Nota'),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: provider.entradaAnualController,
                  decoration: InputDecoration(
                    labelText: 'Entrada anual',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    provider.notifyListeners();
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: provider.fechaActualController,
                  decoration: InputDecoration(
                    labelText: 'Fecha actual entrada',
                    filled: true,
                    fillColor: Colors.grey[300],
                    enabled: false,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
