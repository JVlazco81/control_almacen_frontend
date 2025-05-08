import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/salida_historial.dart';
import '../providers/historial_salidas_provider.dart';
import '../widgets/BaseLayout.dart';
import '../services/historial_salidas_service.dart';

class HistorialSalidasView extends StatefulWidget {
  const HistorialSalidasView({super.key});

  @override
  State<HistorialSalidasView> createState() => _HistorialSalidasViewState();
}

class _HistorialSalidasViewState extends State<HistorialSalidasView> {
  final ScrollController _horizontalScroll = ScrollController();
  final ScrollController _verticalScroll = ScrollController();

  final TextEditingController _searchController = TextEditingController();
  List<SalidaHistorial> _filtradas = [];

  final int filasPorPagina = 10;
  int paginaActual = 0;
  String ordenActual = 'fechaSalida';
  bool ascendente = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<HistorialSalidasProvider>(
        context,
        listen: false,
      );
      await provider.cargarSalidas();
      if (mounted) {
        setState(() {
          _filtradas = List.from(provider.salidas);
          _ordenarSalidas();
        });
      }
    });
  }

  void _buscar(String query) {
    final provider = Provider.of<HistorialSalidasProvider>(
      context,
      listen: false,
    );
    setState(() {
      if (query.isEmpty) {
        _filtradas = List.from(provider.salidas);
      } else {
        _filtradas = provider.salidas.where((e) {
          return e.folio.toLowerCase().contains(query.toLowerCase()) ||
              e.departamento.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      paginaActual = 0;
      _ordenarSalidas();
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
      _ordenarSalidas();
    });
  }

  void _ordenarSalidas() {
    _filtradas.sort((a, b) {
      dynamic valorA, valorB;
      switch (ordenActual) {
        case 'folio':
          valorA = a.folio;
          valorB = b.folio;
          break;
        case 'departamento':
          valorA = a.departamento;
          valorB = b.departamento;
          break;
        case 'fechaSalida':
        default:
          valorA = DateTime.tryParse(a.fechaSalida) ?? DateTime(0);
          valorB = DateTime.tryParse(b.fechaSalida) ?? DateTime(0);
          break;
      }
      return ascendente ? valorA.compareTo(valorB) : valorB.compareTo(valorA);
    });
  }

  List<SalidaHistorial> _paginar(List<SalidaHistorial> lista) {
    int inicio = paginaActual * filasPorPagina;
    int fin = (inicio + filasPorPagina).clamp(0, lista.length);
    return lista.sublist(inicio, fin);
  }

  int _getColumnIndex(String campo) {
    switch (campo) {
      case 'fechaSalida':
        return 0;
      case 'folio':
        return 1;
      case 'departamento':
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
      bodyContent: Consumer<HistorialSalidasProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_filtradas.isEmpty) {
            return const Center(child: Text("No hay salidas registradas."));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Historial de Salidas',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: _buscar,
                  decoration: const InputDecoration(
                    hintText: 'Buscar por número o departamento...',
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
                            headingRowColor: WidgetStateProperty.all(
                              Colors.grey[200],
                            ),
                            columns: [
                              DataColumn(
                                label: const Text('Fecha salida'),
                                onSort: (_, __) => _ordenarPor('fechaSalida'),
                              ),
                              DataColumn(
                                label: const Text('Folio'),
                                onSort: (_, __) => _ordenarPor('folio'),
                              ),
                              DataColumn(
                                label: const Text('Departamento'),
                                onSort: (_, __) =>
                                    _ordenarPor('departamento'),
                              ),
                              const DataColumn(label: Text('Orden Compra')),
                              const DataColumn(label: Text('Salida Anual')),
                              const DataColumn(label: Text('Artículos')),
                              const DataColumn(label: Text('Monto total')),
                              const DataColumn(label: Text('Opciones')),
                            ],
                            rows: _paginar(_filtradas).map((salida) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      _formatearFecha(salida.fechaSalida),
                                    ),
                                  ),
                                  DataCell(Text(salida.folio)),
                                  DataCell(Text(salida.departamento)),
                                  DataCell(Text('${salida.ordenCompra}')),
                                  DataCell(Text('${salida.salidaAnual}')),
                                  // ARTÍCULOS
                                  DataCell(
                                    SizedBox(
                                      height: 80, // altura máxima visible (ajusta a lo que necesites)
                                      child: Scrollbar(
                                        thumbVisibility: true,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: salida.productos.map((p) {
                                              return Text(
                                                '${p.descripcion} x ${p.cantidad}',
                                                style: const TextStyle(fontSize: 12),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // MONTO TOTAL
                                  DataCell(
                                    Text(
                                      '\$${salida.productos.fold<double>(0, (suma, p) => suma + (p.cantidad * p.precio)).toStringAsFixed(2)}',
                                    ),
                                  ),
                                  DataCell(
                                    PopupMenuButton<String>(
                                      icon: const Icon(Icons.more_vert),
                                      onSelected: (value) async {
                                        final provider =
                                            Provider.of<HistorialSalidasProvider>(
                                          context,
                                          listen: false,
                                        );

                                        if (value == 'pdf') {
                                          try {
                                            await HistorialSalidasService.descargarPDFSalida(salida.id);
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    '❌ Error al abrir el PDF: $e'),
                                              ),
                                            );
                                          }
                                        } else if (value == 'eliminar') {
                                          bool confirmar = false;
                                          bool eliminando = false;

                                          await showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (_) {
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        '¿Eliminar salida?'),
                                                    content: const Text(
                                                      'Esta acción no se puede deshacer. ¿Deseas continuar?',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            eliminando
                                                                ? null
                                                                : () =>
                                                                    Navigator.pop(
                                                                        context),
                                                        child: const Text(
                                                            'Cancelar'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: eliminando
                                                            ? null
                                                            : () async {
                                                                setState(() =>
                                                                    eliminando =
                                                                        true);
                                                                confirmar = true;
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                        child: eliminando
                                                            ? const SizedBox(
                                                                width: 18,
                                                                height: 18,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )
                                                            : const Text(
                                                                'Eliminar'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          );

                                          if (confirmar) {
                                            try {
                                              await HistorialSalidasService
                                                  .eliminarSalida(salida.id);
                                              await provider.cargarSalidas();

                                              await showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text(
                                                      'Salida eliminada'),
                                                  content: const Text(
                                                      '✅ La salida ha sido eliminada exitosamente.'),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                          const Text('Aceptar'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } catch (e) {
                                              await showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text(
                                                      'Error al eliminar'),
                                                  content: Text(
                                                      '❌ Ocurrió un error al intentar eliminar la salida.\n$e'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text(
                                                          'Cerrar'),
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
                                              Icon(Icons.picture_as_pdf,
                                                  color: Colors.red),
                                              SizedBox(width: 8),
                                              Text('Ver PDF'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'eliminar',
                                          child: Row(
                                            children: const [
                                              Icon(Icons.delete,
                                                  color: Colors.red),
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
                      onPressed: paginaActual > 0
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
                          (paginaActual + 1) * filasPorPagina < _filtradas.length
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