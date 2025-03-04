import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:control_almacen_frontend/widgets/BaseLayout.dart';

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

  List<String> clasificaciones = [
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
      _calcularTotales();
    });
  }

  void _calcularTotales() {
    double subtotal = totalArticulo;
    double iva = subtotal * 0.16;
    double total = subtotal + iva;

    setState(() {
      subtotalController.text = subtotal.toStringAsFixed(2);
      ivaController.text = iva.toStringAsFixed(2);
      totalController.text = total.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      bodyContent: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entrada de productos al sistema',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Primera tabla (Información de artículos)
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Clave del producto',
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
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
                        child: DropdownSearch<String>(
                          items: clasificaciones,
                          popupProps: PopupProps.menu(showSearchBox: true),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: 'Clasificación',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
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
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Cantidad'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            cantidad = double.tryParse(value) ?? 0;
                            _calcularTotalArticulo();
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Costo por unidad',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            costoUnitario = double.tryParse(value) ?? 0;
                            _calcularTotalArticulo();
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(
                            text: totalArticulo.toStringAsFixed(2),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Total',
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

            // Segunda tabla (Información de la entrada)
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
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

            // Tabla "En espera para ingresar"
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.grey[800],
              child: Center(
                child: Text(
                  'En espera para ingresar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
