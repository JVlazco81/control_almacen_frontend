import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/entradas_provider.dart';
import '../table_cell.dart';

class TablaEspera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EntradasProvider>(context);

    if (provider.listaEspera.isEmpty) {
      return SizedBox(); // Oculta la tabla si no hay elementos en espera
    }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Text(
            'Lista de espera',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          // tabla con scroll horizontal
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FixedColumnWidth(100),
                1: FixedColumnWidth(150),
                2: FixedColumnWidth(120),
                3: FixedColumnWidth(100),
                4: FixedColumnWidth(80),
                5: FixedColumnWidth(80),
                6: FixedColumnWidth(100),
                7: FixedColumnWidth(100), // Opciones
              },
              children: [
                // Encabezado de la tabla
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    TableCellWidget(text: 'Clave', isHeader: true),
                    TableCellWidget(text: 'Descripción', isHeader: true),
                    TableCellWidget(text: 'Marca o Autor', isHeader: true),
                    TableCellWidget(text: 'Unidad', isHeader: true),
                    TableCellWidget(text: 'Cantidad', isHeader: true),
                    TableCellWidget(text: 'Costo', isHeader: true),
                    TableCellWidget(text: 'Total', isHeader: true),
                    TableCellWidget(text: 'Opciones', isHeader: true),
                  ],
                ),
                // Filas dinámicas de la tabla
                ...provider.listaEspera.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> articulo = entry.value;
                  return TableRow(
                    children: [
                      TableCellWidget(text: articulo["claveProducto"]),
                      TableCellWidget(text: articulo["descripcion"]),
                      TableCellWidget(text: articulo["marcaAutor"]),
                      TableCellWidget(text: articulo["unidad"]),
                      TableCellWidget(text: articulo["cantidad"]),
                      TableCellWidget(text: articulo["costo"]),
                      TableCellWidget(text: articulo["total"]),
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
                }).toList(),
              ],
            ),
          ),

          SizedBox(height: 20), // Espaciado antes de los botones

          // Los botones NO están dentro del ScrollView, por lo que NO se afectan
          Wrap(
            spacing: 10, // Espaciado horizontal entre botones
            runSpacing: 10, // Espaciado vertical cuando se acomodan en otra línea
            alignment: WrapAlignment.end, // Alineación a la derecha,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (provider.listaEspera.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("No hay productos en la lista de espera."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (!provider.validarCamposGenerales()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Por favor, complete la información general"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    _mostrarDialogoSubirInventario(context, provider);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Subir al inventario', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () {
                  _mostrarDialogoReiniciar(context, provider);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text('Reiniciar formulario', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoReiniciar(BuildContext context, EntradasProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content: Text("Estás a punto de reiniciar el formulario. ¿Deseas continuar?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar la ventana emergente
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                provider.reiniciarFormulario();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text("Reiniciar formulario", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoEliminar(BuildContext context, EntradasProvider provider, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content: Text("Estás a punto de eliminar este registro. ¿Deseas continuar?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar la ventana emergente
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                provider.eliminarArticulo(index); // 🔹 Elimina el artículo
                Navigator.of(context).pop(); // 🔹 Cierra la ventana después de eliminar
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Eliminar", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }


  void _mostrarDialogoSubirInventario(BuildContext context, EntradasProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false, // Evita que se cierre sin confirmar
      builder: (BuildContext context) {
        return Consumer<EntradasProvider>(
          builder: (context, provider, child) {
            return AlertDialog(
              title: Text("Confirmación"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Estás a punto de subir estos productos al inventario:\n"),
                  ...provider.listaEspera.map((producto) => Text(
                        "${producto["descripcion"]}  x ${producto["cantidad"]}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: provider.isLoading
                      ? null // 🔹 Se deshabilita cuando `isLoading` es `true`
                      : () {
                          if (context.mounted) {
                            Navigator.of(context).pop(); // Cierra la confirmación
                          }
                        },
                  child: Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          provider.setLoading(true);
                          provider.notifyListeners(); // 🔹 Notifica cambios antes de la petición

                          final result = await provider.subirInventario(); // Hace la petición

                          provider.setLoading(false);
                          provider.notifyListeners(); // 🔹 Notifica cambios después de la petición

                          if (context.mounted) {
                            Navigator.of(context).pop(); // Cierra la confirmación

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(result["success"] ? "Éxito" : "Error"),
                                  content: Text(result["success"]
                                      ? "Productos subidos correctamente."
                                      : "Ocurrió un error: ${result["message"]}"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        if (context.mounted) {
                                          Navigator.of(context).pop(); // Cierra el resultado
                                          provider.reiniciarFormulario();
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
                      : Text("Subir al inventario", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}