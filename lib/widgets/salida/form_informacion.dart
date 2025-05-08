import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/salidas_provider.dart';
import '../departamento_selector_dialog.dart';
import '../encargado_selector_dialog.dart';
import 'package:flutter/services.dart';

class FormularioInformacionSalida extends StatelessWidget {
  const FormularioInformacionSalida({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SalidasProvider>(context);

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
            'Información general de la salida',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
          Expanded(
            child: TextField(
              controller: provider.departamentoController,
              decoration: InputDecoration(
                labelText: 'Departamento',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final seleccionado = await showDialog<String>(
                      context: context,
                      builder: (context) => DepartamentoSelectorDialog(),
                    );
                    if (seleccionado != null) {
                      provider.departamentoController.text = seleccionado;
                    }
                  },
                ),
              ),
            ),
          ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: provider.encargadoController,
                  decoration: InputDecoration(
                    labelText: 'Encargado',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        final seleccionado = await showDialog<String>(
                          context: context,
                          builder: (context) => EncargadoSelectorDialog(),
                        );
                        if (seleccionado != null) {
                          provider.encargadoController.text = seleccionado;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: provider.ordenCompraController,
                  decoration: InputDecoration(labelText: 'Orden de compra'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: provider.salidaAnualController,
                  decoration: InputDecoration(
                    labelText: 'Salida anual',
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
                    labelText: 'Fecha actual salida',
                    filled: true,
                    fillColor: Colors.grey[300],
                    enabled: false,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
