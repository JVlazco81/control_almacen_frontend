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
  List<String> clasificaciones = [
    'Clasificación 1',
    'Clasificación 2',
    'Clasificación 3',
    'Clasificación Especial',
    'Otra Clasificación',
  ];

  @override
  void initState() {
    super.initState();
    fechaActualController.text =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
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

            // Primera tabla (Información de la entrada)
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
                              () =>
                                  _selectDate(context, fechaFacturaController),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Folio'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
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
                          decoration: InputDecoration(
                            labelText: 'Entrada anual',
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
                          ),
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Segunda tabla (Información del artículo)
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
                            labelText: 'Nombre/Descripción',
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownSearch<String>(
                          items: clasificaciones,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                labelText: "Buscar clasificación...",
                              ),
                            ),
                          ),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: 'Clasificación',
                            ),
                          ),
                          filterFn: (item, filter) {
                            return item.toLowerCase().contains(
                              filter.toLowerCase(),
                            );
                          },
                          onChanged: (value) {
                            print('Seleccionado: $value');
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Marca o Autor',
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Cantidad'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Costo por unidad',
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
                          decoration: InputDecoration(
                            labelText: 'Total',
                            enabled: false,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () {},
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
