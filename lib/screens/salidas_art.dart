import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:control_almacen_frontend/widgets/BaseLayout.dart';
import '../services/auth_service.dart';

class Salidas_Art extends StatefulWidget {
  const Salidas_Art({super.key});

  @override
  _Salidas_ArtState createState() => _Salidas_ArtState();
}

class _Salidas_ArtState extends State<Salidas_Art> {
  void _verificarSesion() async {
    String? token = await AuthService.getToken();
    if (token == null) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed("/");
      }
    }
  }

  TextEditingController fechaActualController = TextEditingController();
  TextEditingController cantidadSalidaController = TextEditingController(
    text: "1",
  );

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
    _verificarSesion();
    fechaActualController.text =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
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
              'Salida de productos del sistema',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Primera tabla (Información del artículo)
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
                          decoration: InputDecoration(labelText: 'Folio'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Nombre del artículo',
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
                      Expanded(
                        child: NumberInputWithIncrementDecrement(
                          controller: cantidadSalidaController,
                          min: 1,
                          max: 1000,
                          initialValue: 1,
                          incDecFactor: 1,
                          numberFieldDecoration: InputDecoration(
                            labelText: 'Cantidad',
                            border: OutlineInputBorder(),
                          ),
                          widgetContainerDecoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                          ),
                          /*onChanged: (value) {
                            print('Cantidad seleccionada: $value');
                          },*/
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Segunda tabla (Información de salida)
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
                            labelText: 'Departamento',
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Encargado del departamento',
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

            // Tabla "En espera para salir"
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.grey[800],
              child: Center(
                child: Text(
                  'En espera para salir',
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
