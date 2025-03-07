import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:control_almacen_frontend/widgets/BaseLayout.dart';
import 'package:control_almacen_frontend/widgets/table_cell.dart';
import 'package:flutter/services.dart';

class Entradas_Art extends StatefulWidget {
  const Entradas_Art({super.key});

  @override
  _Entradas_ArtState createState() => _Entradas_ArtState();
}

class _Entradas_ArtState extends State<Entradas_Art> {
  TextEditingController fechaFacturaController = TextEditingController();
  TextEditingController fechaActualController = TextEditingController();
  TextEditingController entradaAnualController = TextEditingController();
  TextEditingController subtotalController = TextEditingController(
    text: "0.00",
  );
  TextEditingController proveedorController = TextEditingController();

  TextEditingController ivaController = TextEditingController(text: "0.00");
  TextEditingController totalController = TextEditingController(text: "0.00");

  TextEditingController marcaAutorController = TextEditingController();
  TextEditingController nombreDescripcionController = TextEditingController();
  String? claveProductoSeleccionada;
  String? unidadMedidaSeleccionada;
  TextEditingController cantidadController = TextEditingController();
  TextEditingController costoUnidadController = TextEditingController();
  TextEditingController totalArticuloController = TextEditingController();

  List<String> clavesProducto = [
    'Clasificación 1',
    'Clasificación 2',
    'Clasificación 3',
    'Clasificación Especial',
    'Otra Clasificación',
  ];

  List<String> unidadesMedida = ['PZA', 'CAJA', 'PAQUETE'];

  double cantidad = 0;
  double costoUnitario = 0;
  double totalArticulo = 0;

  List<Map<String, dynamic>> listaEspera = [];
  FocusNode claveProductoFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    fechaActualController.text =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    entradaAnualController.text = "4/${DateTime.now().year}";
  }

void _calcularTotalArticulo() {
  setState(() {
    totalArticulo = cantidad * costoUnitario;
    totalArticuloController.text = totalArticulo.toStringAsFixed(2);
  });
}

void _calcularTotales() {
  double subtotal = 0;

  // Sumar los valores de la lista de espera
  for (var articulo in listaEspera) {
    subtotal += double.tryParse(articulo["total"] ?? "0") ?? 0;
  }

  double iva = subtotal * 0.16;
  double total = subtotal + iva;

  setState(() {
    subtotalController.text = subtotal.toStringAsFixed(2);
    ivaController.text = iva.toStringAsFixed(2);
    totalController.text = total.toStringAsFixed(2);
  });
}

  bool _validarCampos() {
  return marcaAutorController.text.isNotEmpty &&
  nombreDescripcionController.text.isNotEmpty &&
  claveProductoSeleccionada != null &&
  unidadMedidaSeleccionada != null &&
  cantidadController.text.isNotEmpty &&
  costoUnidadController.text.isNotEmpty;
}

void _eliminarArticulo(int index) {
  setState(() {
    listaEspera.removeAt(index); // Eliminar de la lista
    _calcularTotales(); // Recalcular los totales
  });
}

void _editarArticulo(int index) {
  setState(() {
    // Obtener el artículo seleccionado
    Map<String, dynamic> articulo = listaEspera[index];

    // Rellenar los campos del formulario con los datos del artículo
    claveProductoSeleccionada = articulo["clasificacion"];
    nombreDescripcionController.text = articulo["descripcion"];
    marcaAutorController.text = articulo["marcaAutor"];
    unidadMedidaSeleccionada = articulo["unidad"];
    cantidadController.text = articulo["cantidad"];
    costoUnidadController.text = articulo["costo"];
    totalArticuloController.text = articulo["total"];

    // Convertir a valores numéricos para cálculos futuros
    cantidad = double.tryParse(articulo["cantidad"] ?? "0") ?? 0;
    costoUnitario = double.tryParse(articulo["costo"] ?? "0") ?? 0;
    totalArticulo = cantidad * costoUnitario;

    // Eliminar el artículo de la lista
    listaEspera.removeAt(index);

    // Recalcular los totales después de la eliminación
    _calcularTotales();
  });
}

void _mostrarDialogoReiniciar() {
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
              _reiniciarFormulario(); // Llamar a la función que limpia todo
              Navigator.of(context).pop(); // Cerrar el diálogo después de reiniciar
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text("Reiniciar formulario", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

void _reiniciarFormulario() {
  setState(() {
    // Limpiar los campos del formulario
    proveedorController.clear();
    fechaFacturaController.clear();
    marcaAutorController.clear();
    nombreDescripcionController.clear();
    claveProductoSeleccionada = null;
    unidadMedidaSeleccionada = null;
    cantidadController.clear();
    costoUnidadController.clear();
    totalArticulo = 0;
    totalArticuloController.text = "0.00";

    // Limpiar la lista de espera
    listaEspera.clear();

    // Reiniciar los totales
    _calcularTotales();

    // Forzar focus a Clave del Producto
    FocusScope.of(context).requestFocus(claveProductoFocus);
  });
}

bool _validarCamposGenerales() {
  return proveedorController.text.isNotEmpty && fechaFacturaController.text.isNotEmpty;
}

void _mostrarDialogoSubirInventario() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirmación"),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Evita que el diálogo sea demasiado grande
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Estás a punto de subir estos productos al inventario:\n"),
            //  Mostrar el listado de productos
            ...listaEspera.map((producto) => Text(
                  "${producto["descripcion"]}  x ${producto["cantidad"]}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo sin hacer nada
            },
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              // Aquí se implementará la lógica para subir al inventario
              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text("Subir al inventario", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      bodyContent: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entrada de productos al sistema',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Primer contenedor (Información de la entrada)
              Container(
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
                            controller: proveedorController,
                            decoration: InputDecoration(labelText: 'Proveedor'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: fechaFacturaController,
                            decoration: InputDecoration(
                              labelText: 'Fecha de la factura',
                            ),
                            readOnly: true,
                            onTap:
                                () => showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                ).then((pickedDate) {
                                  if (pickedDate != null) {
                                    setState(() {
                                      fechaFacturaController.text =
                                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                    });
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
                            controller: entradaAnualController,
                            decoration: InputDecoration(
                              labelText: 'Entrada anual',
                              labelStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.grey[300],
                              enabled: false,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: fechaActualController,
                            decoration: InputDecoration(
                              labelText: 'Fecha actual',
                              labelStyle: TextStyle(color: Colors.black),
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
              ),

              SizedBox(height: 20),

              // Segundo contenedor (Información de productos)
              Container(
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
                            items: clavesProducto,
                            selectedItem: claveProductoSeleccionada,
                            popupProps: PopupProps.menu(showSearchBox: true),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Clave del producto',
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                claveProductoSeleccionada = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: nombreDescripcionController,
                            decoration: InputDecoration(
                              labelText: 'Nombre/Descripción',
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
                            controller: marcaAutorController,
                            decoration: InputDecoration(
                              labelText: 'Marca o Autor',
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: unidadMedidaSeleccionada,
                            items:
                                unidadesMedida
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                            decoration: InputDecoration(
                              labelText: 'Unidad de medida',
                            ),
                            onChanged: (value) {
                              unidadMedidaSeleccionada = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller:cantidadController,
                            decoration: InputDecoration(labelText: 'Cantidad'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Restringe solo a números enteros
                            onChanged: (value) {
                              cantidad = double.tryParse(value) ?? 0;
                              _calcularTotalArticulo();
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: costoUnidadController,
                            decoration: InputDecoration(
                              labelText: 'Costo por unidad',
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true), // Activa el punto decimal en móviles
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')), // Permite decimales con 2 dígitos
                            ],
                            onChanged: (value) {
                              costoUnitario = double.tryParse(value) ?? 0;
                              _calcularTotalArticulo();
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: totalArticuloController,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Alinea los botones a la derecha
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if(_validarCampos()){
                              setState(() {
                                // Agregar los datos a la lista de espera
                                listaEspera.add({
                                  "clasificacion": claveProductoSeleccionada ?? '',
                                  "descripcion": nombreDescripcionController.text,
                                  "marcaAutor": marcaAutorController.text,
                                  "unidad": unidadMedidaSeleccionada ?? '',
                                  "cantidad": cantidadController.text,
                                  "costo": costoUnidadController.text,
                                  "total": totalArticulo.toStringAsFixed(2),
                                });

                                // Limpiar los campos
                                marcaAutorController.clear();
                                nombreDescripcionController.clear();
                                cantidadController.clear();
                                costoUnidadController.clear();
                                claveProductoSeleccionada = null;
                                unidadMedidaSeleccionada = null;
                                totalArticulo = 0;
                                totalArticuloController.text = "0.00";

                                // Recalcular totales del contenedor 1
                                _calcularTotales();

                                // Forzar el focus a Clave del Producto
                                FocusScope.of(context).requestFocus(claveProductoFocus);
                              });
                            } else {
                              // Mostrar alerta si falta algún campo
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Por favor, complete todos los campos."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          //style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                          child: Text('Agregar a espera'),
                        ),
                        SizedBox(width: 10), // Espaciado entre botones
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              marcaAutorController.clear();
                              nombreDescripcionController.clear();
                              claveProductoSeleccionada = null;
                              unidadMedidaSeleccionada = null;
                              cantidadController.clear();
                              costoUnidadController.clear();
                              totalArticulo = 0;
                              totalArticuloController.text = "0.00";
                              // Forzar focus a Clave del Producto
                              FocusScope.of(context).requestFocus(claveProductoFocus);
                            });
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: Text('Vaciar', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              
              //Contenedor totales
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200], // Color de fondo sutil
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen de Totales',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: subtotalController,
                            decoration: InputDecoration(
                              labelText: 'Subtotal',
                              labelStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.grey[300],
                              enabled: false,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: ivaController,
                            decoration: InputDecoration(
                              labelText: 'IVA (16%)',
                              labelStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.grey[300],
                              enabled: false,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: totalController,
                            decoration: InputDecoration(
                              labelText: 'Total (con IVA)',
                              labelStyle: TextStyle(color: Colors.black),
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
              ),
              
              SizedBox(height: 20),
              
              // Tabla de espera
              listaEspera.isNotEmpty
              ? Container(
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
                      Table(
                        border: TableBorder.all(),
                        columnWidths: {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1),
                          4: FlexColumnWidth(1),
                          5: FlexColumnWidth(1),
                          6: FlexColumnWidth(1),
                          7: FlexColumnWidth(1), // opciones
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
                          ...listaEspera.asMap().entries.map((entry) {
                            int index = entry.key; // Obtener el índice
                            Map<String, dynamic> articulo = entry.value; // Obtener el artículo
                            return TableRow(
                              children: [
                                TableCellWidget(text: articulo["clasificacion"]),
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
                                        _editarArticulo(index);
                                      } else if (value == "eliminar") {
                                        _eliminarArticulo(index);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: "editar",
                                        child: Row(
                                          children: [Icon(Icons.edit, color: Colors.blue), SizedBox(width: 5), Text("Modificar")],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: "eliminar",
                                        child: Row(
                                          children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 5), Text("Eliminar")],
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
                      SizedBox(height: 20), // Espaciado antes de los botones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end, // Alinear a la derecha
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (listaEspera.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("No hay productos en la lista de espera."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (!_validarCamposGenerales()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Por favor, complete la información del proveedor y la fecha de la factura."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                _mostrarDialogoSubirInventario();
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: Text('Subir al inventario', style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(width: 10), // Espaciado entre botones
                          ElevatedButton(
                            onPressed: () {
                              _mostrarDialogoReiniciar();
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            child: Text('Reiniciar formulario', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : SizedBox(), // Oculta la tabla si no hay elementos en espera
            ],
          ),
        ),
      ),
    );
  }
}