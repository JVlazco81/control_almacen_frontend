import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/historial_cambio.dart';
import '../providers/historial_cambios_provider.dart';
import '../widgets/BaseLayout.dart';

class HistorialCambiosView extends StatefulWidget {
  const HistorialCambiosView({super.key});

  @override
  State<HistorialCambiosView> createState() => _HistorialCambiosViewState();
}

class _HistorialCambiosViewState extends State<HistorialCambiosView> {
  List<HistorialCambio> historialFiltrado = [];
  final int filasPorPagina = 10;
  int paginaActual = 0;
  TextEditingController searchController = TextEditingController();

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<HistorialCambiosProvider>(
        context,
        listen: false,
      );
      provider.cargarHistorial().then((_) {
        if (mounted) {
          setState(() {
            historialFiltrado = List.from(provider.historial);
          });
        }
      });
    });
  }

  void _filtrarHistorial(String query) {
    final provider = Provider.of<HistorialCambiosProvider>(
      context,
      listen: false,
    );
    setState(() {
      if (query.isEmpty) {
        historialFiltrado = List.from(provider.historial);
      } else {
        final filtro = query.toLowerCase();
        historialFiltrado =
            provider.historial.where((item) {
              return item.accion.toLowerCase().contains(filtro) ||
                  item.usuario.toLowerCase().contains(filtro) ||
                  item.fecha.toLowerCase().contains(filtro);
            }).toList();
      }
      paginaActual = 0;
    });
  }

  String _formatearFecha(String fechaOriginal) {
    try {
      DateTime fecha = DateTime.parse(fechaOriginal);
      return DateFormat("d 'de' MMMM 'de' y, h:mm a", 'es_MX').format(fecha);
    } catch (_) {
      return fechaOriginal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      bodyContent: Consumer<HistorialCambiosProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.historial.isEmpty) {
            return const Center(
              child: Text('No se han registrado cambios en los productos'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: _filtrarHistorial,
                  decoration: InputDecoration(
                    hintText: 'Buscar por acción, usuario o fecha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Scrollbar(
                    controller: _horizontalScrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        child: SingleChildScrollView(
                          controller: _verticalScrollController,
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columnSpacing: 20,
                            headingRowHeight: 40,
                            dataRowHeight: 80,
                            headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.grey.shade300,
                            ),
                            border: TableBorder.all(color: Colors.black12),
                            columns: const [
                              DataColumn(label: Text('Acción')),
                              DataColumn(label: Text('Usuario')),
                              DataColumn(label: Text('Fecha')),
                              DataColumn(label: Text('Detalles')),
                            ],
                            rows:
                                _paginar(historialFiltrado).map((item) {
                                  final cambios = <Widget>[];

                                  if (item.valorAnterior != null &&
                                      item.valorNuevo != null) {
                                    item.valorAnterior!.forEach((key, oldVal) {
                                      final newVal = item.valorNuevo![key];

                                      final oldStr = oldVal.toString().trim();
                                      final newStr = newVal?.toString().trim();

                                      if (newStr != null && newStr != oldStr) {
                                        cambios.add(
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 2.0,
                                            ),
                                            child: RichText(
                                              text: TextSpan(
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: "$key: ",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "$oldStr → $newStr",
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    });
                                  }

                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.accion)),
                                      DataCell(Text(item.usuario)),
                                      DataCell(
                                        Text(_formatearFecha(item.fecha)),
                                      ),
                                      DataCell(
                                        cambios.isEmpty
                                            ? const Text(
                                              "Sin cambios detectables",
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey,
                                              ),
                                            )
                                            : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: cambios,
                                            ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed:
                          paginaActual > 0
                              ? () => setState(() => paginaActual--)
                              : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Anterior"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "Página ${paginaActual + 1} de ${_totalPaginas(historialFiltrado).clamp(1, double.infinity).toInt()}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed:
                          (paginaActual + 1) * filasPorPagina <
                                  historialFiltrado.length
                              ? () => setState(() => paginaActual++)
                              : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Siguiente"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                      ),
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

  List<HistorialCambio> _paginar(List<HistorialCambio> datos) {
    int inicio = paginaActual * filasPorPagina;
    int fin = inicio + filasPorPagina;
    return datos.sublist(inicio, fin > datos.length ? datos.length : fin);
  }

  int _totalPaginas(List<HistorialCambio> datos) {
    return (datos.length / filasPorPagina).ceil();
  }
}
