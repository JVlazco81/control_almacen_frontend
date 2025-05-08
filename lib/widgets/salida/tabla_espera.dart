import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/salidas_provider.dart';

class TablaEsperaSalida extends StatelessWidget {
  const TablaEsperaSalida({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SalidasProvider>(context);

    if (provider.listaEspera.isEmpty) return SizedBox();

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lista de productos en espera', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Table(
            border: TableBorder.all(),
            columnWidths: {
              0: FixedColumnWidth(100),
              1: FixedColumnWidth(200),
              2: FixedColumnWidth(100),
              3: FixedColumnWidth(80),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[300]),
                children: [
                  _cellHeader('Folio'),
                  _cellHeader('Descripción'),
                  _cellHeader('Cantidad'),
                  _cellHeader('Opciones')
                ],
              ),
              ...provider.listaEspera.asMap().entries.map((entry) {
                int index = entry.key;
                final prod = entry.value;
                return TableRow(
                  children: [
                    _cellText(prod["folio"].toString()),
                    _cellText(prod["descripcion"].toString()),
                    _cellText(prod["cantidad"].toString()),
                    TableCell(
                      child: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == "editar") {
                            provider.editarArticulo(index);
                          } else if (value == "eliminar") {
                            _mostrarDialogoEliminar(context, provider, index);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: "editar",
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 5),
                                Text("Modificar"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: "eliminar",
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 5),
                                Text("Eliminar"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            alignment: WrapAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (!provider.validarCamposGenerales()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Completa la información general primero"),
                      backgroundColor: Colors.red,
                    ));
                    return;
                  }

                  if (provider.listaEspera.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("No hay productos agregados"),
                      backgroundColor: Colors.red,
                    ));
                    return;
                  }

                  _mostrarDialogoRegistrarSalida(context, provider);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text("Enviar salida", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () => _mostrarDialogoReiniciar(context, provider),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text("Reiniciar", style: TextStyle(color: Colors.white)),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _mostrarDialogoEliminar(BuildContext context, SalidasProvider provider, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content: Text("¿Deseas eliminar este producto de la lista de espera?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                provider.eliminarArticulo(index);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Eliminar", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoReiniciar(BuildContext context, SalidasProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content: Text("Estás a punto de reiniciar el formulario. ¿Deseas continuar?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                provider.reiniciarFormulario();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text("Reiniciar", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoRegistrarSalida(BuildContext context, SalidasProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Consumer<SalidasProvider>(
          builder: (context, provider, child) {
            return AlertDialog(
              title: Text("Confirmación"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Estás a punto de registrar esta salida de productos:\n"),
                  ...provider.listaEspera.map((producto) => Text(
                        "${producto["descripcion"]}  x ${producto["cantidad"]}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: provider.isLoading
                      ? null
                      : () {
                          if (context.mounted) Navigator.of(context).pop();
                        },
                  child: Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          provider.setLoading(true);
                          provider.notifyListeners();

                          final result = await provider.enviarSalida();

                          provider.setLoading(false);
                          provider.notifyListeners();

                          if (context.mounted) {
                            Navigator.of(context).pop();

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(result["success"] ? "Éxito" : "Error"),
                                  content: Text(result["success"]
                                      ? "Salida registrada correctamente."
                                      : "Ocurrió un error: ${result["message"]}"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                          if (result["success"]) {
                                            provider.reiniciarFormulario();
                                          }
                                        }
                                      },
                                      child: Text("Cerrar"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: provider.isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Registrar salida", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Widget _cellHeader(String text) => Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget _cellText(String text) => Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(text),
      );
}
