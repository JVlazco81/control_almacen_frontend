import 'package:flutter/material.dart';
import 'package:control_almacen_frontend/widgets/BaseLayout.dart';

class Existencias_View extends StatefulWidget {
  const Existencias_View({super.key});

  @override
  _ExistenciasViewState createState() => _ExistenciasViewState();
}

class _ExistenciasViewState extends State<Existencias_View> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  final int filasPorPagina = 10;
  int paginaActual = 0;

  final List<Map<String, String>> productos = List.generate(50, (index) {
    return {
      "num": "${index + 1}",
      "clave": "A-${100 + index}",
      "nombre": "Producto ${index + 1}",
      "marca": "Marca ${index % 5}",
      "unidad": "PZA",
      "existencias": "${(index + 1) * 2}",
      "costo": "${(index + 1) * 100}",
      "subtotal": "${(index + 1) * 200}",
      "iva": "${(index + 1) * 32}",
      "total": "${(index + 1) * 232}",
    };
  });

  List<Map<String, String>> filteredProductos = [];

  @override
  void initState() {
    super.initState();
    filteredProductos = List.from(productos);
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  void _filtrarProductos(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProductos = List.from(productos);
      } else {
        filteredProductos =
            productos.where((producto) {
              final nombre = producto["nombre"]!.toLowerCase();
              final clave = producto["clave"]!.toLowerCase();
              final marca = producto["marca"]!.toLowerCase();
              final filtro = query.toLowerCase();

              return nombre.contains(filtro) ||
                  clave.contains(filtro) ||
                  marca.contains(filtro);
            }).toList();
      }
      paginaActual = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    int inicio = paginaActual * filasPorPagina;
    int fin = inicio + filasPorPagina;
    List<Map<String, String>> productosPaginados = filteredProductos.sublist(
      inicio,
      fin > filteredProductos.length ? filteredProductos.length : fin,
    );

    return BaseLayout(
      bodyContent: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color.fromARGB(255, 240, 240, 240),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: _filtrarProductos,
                    decoration: InputDecoration(
                      hintText: 'Buscar producto por nombre, clave o marca',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Row(
                  children: [
                    Text(
                      'Generar vale de existencias',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      icon: Icon(Icons.picture_as_pdf, size: 24),
                      onPressed: () {
                        // Aquí puedes agregar la funcionalidad de generar PDF
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),

            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      controller: _horizontalScrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width,
                          ),
                          child: Scrollbar(
                            controller: _verticalScrollController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _verticalScrollController,
                              scrollDirection: Axis.vertical,
                              child:
                                  filteredProductos.isEmpty
                                      ? Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          "No hay resultados para esta búsqueda.",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                      : DataTable(
                                        columnSpacing:
                                            12, // Reducir espacio entre columnas
                                        headingRowHeight:
                                            36, // Reducir altura del encabezado
                                        dataRowHeight:
                                            36, // Reducir altura de las filas
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                              (states) => Colors.grey[300]!,
                                            ),
                                        border: TableBorder.all(
                                          color: Colors.black,
                                        ),
                                        columns: const [
                                          DataColumn(label: Text('NUM')),
                                          DataColumn(
                                            label: Text('CLAVE DEL PRODUCTO'),
                                          ),
                                          DataColumn(
                                            label: Text('NOMBRE/DESCRIPCIÓN'),
                                          ),
                                          DataColumn(
                                            label: Text('MARCA/AUTOR'),
                                          ),
                                          DataColumn(
                                            label: Text('UNIDAD DE MEDIDA'),
                                          ),
                                          DataColumn(
                                            label: Text('EXISTENCIAS'),
                                          ),
                                          DataColumn(
                                            label: Text('COSTOS POR UNIDAD'),
                                          ),
                                          DataColumn(label: Text('SUB TOTAL')),
                                          DataColumn(label: Text('IVA (16%)')),
                                          DataColumn(
                                            label: Text('MONTO TOTAL'),
                                          ),
                                        ],
                                        rows:
                                            productosPaginados
                                                .map(
                                                  (producto) => DataRow(
                                                    cells: [
                                                      DataCell(
                                                        Text(producto["num"]!),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          producto["clave"]!,
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          producto["nombre"]!,
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          producto["marca"]!,
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          producto["unidad"]!,
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          producto["existencias"]!,
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          "\$${producto["costo"]!}",
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          "\$${producto["subtotal"]!}",
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          "\$${producto["iva"]!}",
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          "\$${producto["total"]!}",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                                .toList(),
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32), // Más separación antes de la paginación

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:
                            paginaActual > 0
                                ? () {
                                  setState(() {
                                    paginaActual--;
                                  });
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                        ),
                        child: Text('Anterior'),
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Página ${paginaActual + 1} de ${((filteredProductos.length / filasPorPagina).ceil()).clamp(1, double.infinity).toInt()}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 15),
                      ElevatedButton(
                        onPressed:
                            (paginaActual + 1) * filasPorPagina <
                                    filteredProductos.length
                                ? () {
                                  setState(() {
                                    paginaActual++;
                                  });
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[200],
                          foregroundColor: Colors.black,
                        ),
                        child: Text('Siguiente'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
