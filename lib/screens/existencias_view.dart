import 'package:flutter/material.dart';
import 'package:control_almacen_frontend/widgets/BaseLayout.dart';

class Existencias_View extends StatelessWidget {
  const Existencias_View({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      bodyContent: Container(
        color: const Color.fromARGB(
          255,
          240,
          240,
          240,
        ), // Cambia el fondo por ejemplo
        child: Center(
          child: Column(
            children: [
              Text(
                'Vista General',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
              SizedBox(height: 20), // Espacio entre el título y la tabla
              Table(
                border: TableBorder.all(
                  color: Colors.black,
                ), // Borde de la tabla
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Col 1',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Col 2',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Col 3',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Col 4',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Col 5',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Col 6',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Col 7',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Col 8',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Col 9',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Col 10',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Puedes agregar más filas aquí si lo deseas
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
