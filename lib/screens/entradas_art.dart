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
                              labelText: 'Total (artículo)',
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
                              totalArticuloController.clear();

                              // Forzar focus a Clave del Producto
                              FocusScope.of(context).requestFocus(claveProductoFocus);

                              _calcularTotalArticulo();
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
                            ],
                          ),
                          // Filas dinámicas de la tabla
                          ...listaEspera.map((articulo) {
                            return TableRow(
                              children: [
                                TableCellWidget(text: articulo["clasificacion"]),
                                TableCellWidget(text: articulo["descripcion"]),
                                TableCellWidget(text: articulo["marcaAutor"]),
                                TableCellWidget(text: articulo["unidad"]),
                                TableCellWidget(text: articulo["cantidad"]),
                                TableCellWidget(text: articulo["costo"]),
                                TableCellWidget(text: articulo["total"]),
                              ],
                            );
                          }).toList(),
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
