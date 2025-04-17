import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/entrada_historial.dart';
import '../providers/historial_entradas_provider.dart';
import '../widgets/BaseLayout.dart';

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

  void _abrirPDF(int idEntrada) async {
    final url = Uri.parse(
      'http://192.168.0.21:80/api/vale-salida/$idEntrada?pdf=true',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No se pudo abrir el PDF")));
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
                              const DataColumn(label: Text('Año')),
                              const DataColumn(label: Text('Artículos')),
                              const DataColumn(label: Text('Monto total')),
                              const DataColumn(label: Text('PDF')),
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
                                      const DataCell(Text('Pendiente')),
                                      const DataCell(Text('Pendiente')),
                                      DataCell(
                                        IconButton(
                                          icon: const Icon(
                                            Icons.picture_as_pdf,
                                            color: Colors.red,
                                          ),
                                          tooltip: "Ver PDF",
                                          onPressed:
                                              () => _abrirPDF(entrada.id),
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
