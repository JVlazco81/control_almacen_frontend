import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/entrada_historial.dart';
import '../providers/historial_entradas_provider.dart';
import '../widgets/BaseLayout.dart';
import '../services/historial_entrada_service.dart';

class HistorialEntradasView extends StatefulWidget {
  const HistorialEntradasView({super.key});

  @override
  State<HistorialEntradasView> createState() => _HistorialEntradasViewState();
}

class _HistorialEntradasViewState extends State<HistorialEntradasView> {
  final ScrollController _horizontalScroll = ScrollController();
  final ScrollController _verticalScroll = ScrollController();

  final TextEditingController _searchController = TextEditingController();
  List<EntradaHistorial> _filtradas = [];

  final int filasPorPagina = 10;
  int paginaActual = 0;
  String ordenActual = 'fechaEntrada';
  bool ascendente = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<HistorialEntradasProvider>(
        context,
        listen: false,
      );
      await provider.cargarEntradas();
      if (mounted) {
        setState(() {
          _filtradas = List.from(provider.entradas);
          _ordenarEntradas();
        });
      }
    });
  }

  void _buscar(String query) {
    final provider = Provider.of<HistorialEntradasProvider>(
      context,
      listen: false,
    );
    setState(() {
      if (query.isEmpty) {
        _filtradas = List.from(provider.entradas);
      } else {
        _filtradas =
            provider.entradas.where((e) {
              return e.folio.toLowerCase().contains(query.toLowerCase()) ||
                  e.proveedor.toLowerCase().contains(query.toLowerCase());
            }).toList();
      }
      paginaActual = 0;
      _ordenarEntradas();
    });
  }

  void _ordenarPor(String campo) {
    setState(() {
      if (ordenActual == campo) {
        ascendente = !ascendente;
      } else {
        ordenActual = campo;
        ascendente = true;
      }
      _ordenarEntradas();
    });
  }

  void _ordenarEntradas() {
    _filtradas.sort((a, b) {
      dynamic valorA, valorB;
      switch (ordenActual) {
        case 'folio':
          valorA = a.folio;
          valorB = b.folio;
          break;
        case 'proveedor':
          valorA = a.proveedor;
          valorB = b.proveedor;
          break;
        case 'fechaEntrada':
        default:
          valorA = DateTime.tryParse(a.fechaEntrada) ?? DateTime(0);
          valorB = DateTime.tryParse(b.fechaEntrada) ?? DateTime(0);
          break;
      }
      return ascendente ? valorA.compareTo(valorB) : valorB.compareTo(valorA);
    });
  }

  List<EntradaHistorial> _paginar(List<EntradaHistorial> lista) {
    int inicio = paginaActual * filasPorPagina;
    int fin = (inicio + filasPorPagina).clamp(0, lista.length);
    return lista.sublist(inicio, fin);
  }

  int _getColumnIndex(String campo) {
    switch (campo) {
      case 'fechaEntrada':
        return 0;
      case 'folio':
        return 1;
      case 'proveedor':
        return 2;
      default:
        return 0;
    }
  }

  String _formatearFecha(String fecha) {
    try {
      final date = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy hh:mm a').format(date);
    } catch (_) {
      return fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      bodyContent: Consumer<HistorialEntradasProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_filtradas.isEmpty) {
            return const Center(child: Text("No hay entradas registradas."));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Historial de Entradas',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: _buscar,
                  decoration: const InputDecoration(
                    hintText: 'Buscar por número o proveedor...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Scrollbar(
                    controller: _horizontalScroll,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _horizontalScroll,
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        child: SingleChildScrollView(
                          controller: _verticalScroll,
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            sortColumnIndex: _getColumnIndex(ordenActual),
                            sortAscending: ascendente,
                            headingRowColor: MaterialStateProperty.all(
                              Colors.grey[200],
                            ),
                            columns: [
                              DataColumn(
                                label: const Text('Fecha ingreso'),
                                onSort: (_, __) => _ordenarPor('fechaEntrada'),
                              ),
                              DataColumn(
                                label: const Text('Folio'),
                                onSort: (_, __) => _ordenarPor('folio'),
                              ),
                              DataColumn(
                                label: const Text('Proveedor'),
                                onSort: (_, __) => _ordenarPor('proveedor'),
                              ),
                              const DataColumn(label: Text('Fecha factura')),
                              const DataColumn(label: Text('Nota')),
                              const DataColumn(label: Text('Entrada')),
                              const DataColumn(label: Text('Artículos')),
                              const DataColumn(label: Text('Monto total')),
                              const DataColumn(label: Text('Opciones')),
                            ],
                            rows:
                                _paginar(_filtradas).map((entrada) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          _formatearFecha(entrada.fechaEntrada),
                                        ),
                                      ),
                                      DataCell(Text(entrada.folio)),
                                      DataCell(Text(entrada.proveedor)),
                                      DataCell(
                                        Text(
                                          _formatearFecha(entrada.fechaFactura),
                                        ),
                                      ),
                                      DataCell(Text(entrada.nota ?? '-')),
                                      DataCell(Text('${entrada.entradaAnual}')),
                                      //ARTÍCULOS
                                      DataCell(
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: entrada.productos.map((producto) {
                                            return Text(
                                              '${producto.descripcion} x ${producto.cantidad}',
                                              style: const TextStyle(fontSize: 12),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      //MONTO TOTAL
                                      DataCell(
                                        Text(
                                          '\$${entrada.productos.fold<double>(0, (suma, p) => suma + (p.cantidad * p.precio)).toStringAsFixed(2)}',
                                        ),
                                      ),
                                      DataCell(
                                        PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_vert),
                                          onSelected: (value) async {
                                            final provider = Provider.of<HistorialEntradasProvider>(context, listen: false);

                                            if (value == 'pdf') {
                                              try {
                                                await HistorialEntradasService.abrirPDF(entrada.id);
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('❌ Error al abrir el PDF: $e')),
                                                );
                                              }
                                            } else if (value == 'eliminar') {
                                              bool confirmar = false;
                                              bool _eliminando = false;

                                              await showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (_) {
                                                  return StatefulBuilder(
                                                    builder: (context, setState) {
                                                      return AlertDialog(
                                                        title: const Text('¿Eliminar entrada?'),
                                                        content: const Text(
                                                          'Esta acción no se puede deshacer. ¿Deseas continuar?',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: _eliminando ? null : () => Navigator.pop(context),
                                                            child: const Text('Cancelar'),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: _eliminando
                                                                ? null
                                                                : () async {
                                                                    setState(() => _eliminando = true);
                                                                    confirmar = true;
                                                                    Navigator.pop(context);
                                                                  },
                                                            child: _eliminando
                                                                ? const SizedBox(
                                                                    width: 18,
                                                                    height: 18,
                                                                    child: CircularProgressIndicator(
                                                                      strokeWidth: 2,
                                                                      color: Colors.white,
                                                                    ),
                                                                  )
                                                                : const Text('Eliminar'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              );

                                              if (confirmar) {
                                                try {
                                                  await HistorialEntradasService.eliminarEntrada(entrada.id);
                                                  await provider.cargarEntradas();

                                                  await showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      title: const Text('Entrada eliminada'),
                                                      content: const Text('✅ La entrada ha sido eliminada exitosamente.'),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: const Text('Aceptar'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } catch (e) {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      title: const Text('Error al eliminar'),
                                                      content: Text('❌ Ocurrió un error al intentar eliminar la entrada.\n$e'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: const Text('Cerrar'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              }
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 'pdf',
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.picture_as_pdf, color: Colors.red),
                                                  SizedBox(width: 8),
                                                  Text('Ver PDF'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'eliminar',
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.delete, color: Colors.red),
                                                  SizedBox(width: 8),
                                                  Text('Eliminar'),
                                                ],
                                              ),
                                            ),
                                          ],
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
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "Página ${paginaActual + 1} de ${(_filtradas.length / filasPorPagina).ceil()}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed:
                          (paginaActual + 1) * filasPorPagina <
                                  _filtradas.length
                              ? () => setState(() => paginaActual++)
                              : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Siguiente"),
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