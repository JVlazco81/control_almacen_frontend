import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventario_provider.dart';
import '../models/producto.dart';
import '../widgets/BaseLayout.dart';
import '../services/auth_service.dart';

class Existencias_View extends StatefulWidget {
  const Existencias_View({super.key});

  @override
  _ExistenciasViewState createState() => _ExistenciasViewState();
}

class _ExistenciasViewState extends State<Existencias_View> {
  void _verificarSesion() async {
    String? token = await AuthService.getToken();
    if (token == null) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed("/");
      }
    }
  }
  
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  final int filasPorPagina = 10;
  int paginaActual = 0;
  List<Producto> productosFiltrados = [];

  @override
  void initState() { 
    super.initState();
    _verificarSesion();
    final provider = Provider.of<InventarioProvider>(context, listen: false);
    provider.cargarInventario().then((_) {
      setState(() {
        productosFiltrados = List.from(provider.inventario);
      });
    });
  }

  void _filtrarProductos(String query) {
    final provider = Provider.of<InventarioProvider>(context, listen: false);
    setState(() {
      if (query.isEmpty) {
        productosFiltrados = List.from(provider.inventario);
      } else {
        productosFiltrados = provider.inventario.where((producto) {
          final descripcion = producto.descripcion.toLowerCase();
          final clave = producto.claveProducto.toString().toLowerCase();
          final categoria = producto.categoria.toLowerCase();
          final filtro = query.toLowerCase();

          return descripcion.contains(filtro) ||
              clave.contains(filtro) ||
              categoria.contains(filtro);
        }).toList();
      }
      paginaActual = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      bodyContent: Consumer<InventarioProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.inventario.isEmpty) {
            return Center(child: Text("No hay productos en el inventario."));
          }

          int inicio = paginaActual * filasPorPagina;
          int fin = inicio + filasPorPagina;
          List<Producto> productosPaginados =
              productosFiltrados.sublist(inicio, fin > productosFiltrados.length ? productosFiltrados.length : fin);

          return Container(
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
                          hintText: 'Buscar producto por descripción, clave o categoría',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Row(
                      children: [
                        Text('Generar vale de existencias', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 5),
                        IconButton(
                          icon: Icon(Icons.picture_as_pdf, size: 24),
                          onPressed: () {
                            // Funcionalidad de generar PDF
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),

                Expanded(
                  child: SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                      child: SingleChildScrollView(
                        controller: _verticalScrollController,
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columnSpacing: 12,
                          headingRowHeight: 40,
                          dataRowHeight: 40,
                          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[300]!),
                          border: TableBorder.all(color: Colors.black),
                          columns: const [
                            DataColumn(label: Text('NUM')),
                            DataColumn(label: Text('CLAVE DEL PRODUCTO')),
                            DataColumn(label: Text('DESCRIPCIÓN')),
                            DataColumn(label: Text('MARCA/AUTOR')),
                            DataColumn(label: Text('CATEGORÍA')),
                            DataColumn(label: Text('UNIDAD')),
                            DataColumn(label: Text('EXISTENCIAS')),
                            DataColumn(label: Text('COSTO POR UNIDAD')),
                            DataColumn(label: Text('SUBTOTAL')),
                            DataColumn(label: Text('IVA (16%)')),
                            DataColumn(label: Text('MONTO TOTAL')),
                          ],
                          rows: productosPaginados.map((producto) {
                            return DataRow(
                              cells: [
                                DataCell(Text("${producto.num}")),
                                DataCell(Text("${producto.claveProducto}")),
                                DataCell(Text(producto.descripcion)),
                                DataCell(Text(producto.marcaAutor ?? "-")),
                                DataCell(Text(producto.categoria)),
                                DataCell(Text(producto.unidad)),
                                DataCell(Text("${producto.existencias}")),
                                DataCell(Text("\$${producto.costoPorUnidad.toStringAsFixed(2)}")),
                                DataCell(Text("\$${producto.subtotal.toStringAsFixed(2)}")),
                                DataCell(Text("\$${producto.iva.toStringAsFixed(2)}")),
                                DataCell(Text("\$${producto.montoTotal.toStringAsFixed(2)}")),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: paginaActual > 0
                          ? () {
                              setState(() {
                                paginaActual--;
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300], foregroundColor: Colors.black),
                      child: Text('Anterior'),
                    ),
                    SizedBox(width: 15),
                    Text(
                      'Página ${paginaActual + 1} de ${((productosFiltrados.length / filasPorPagina).ceil()).clamp(1, double.infinity).toInt()}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: (paginaActual + 1) * filasPorPagina < productosFiltrados.length
                          ? () {
                              setState(() {
                                paginaActual++;
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple[200], foregroundColor: Colors.black),
                      child: Text('Siguiente'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}