import 'package:flutter/material.dart';
import '../widgets/BaseLayout.dart';

class HistorialSalidasView extends StatefulWidget {
  const HistorialSalidasView({super.key});

  @override
  State<HistorialSalidasView> createState() => _HistorialSalidasViewState();
}

class _HistorialSalidasViewState extends State<HistorialSalidasView> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> datos = [];
  List<Map<String, String>> filtrados = [];
  int paginaActual = 0;
  final int filasPorPagina = 10;

  @override
  void initState() {
    super.initState();
    datos = List.generate(
      20,
      (i) => {
        "folio": "S-${i + 1}",
        "usuario": "Usuario ${i + 1}",
        "fecha": "2024-03-${(i % 28) + 1}",
      },
    );
    filtrados = List.from(datos);
  }

  void _filtrar(String texto) {
    setState(() {
      if (texto.isEmpty) {
        filtrados = List.from(datos);
      } else {
        filtrados =
            datos
                .where(
                  (e) =>
                      e["folio"]!.toLowerCase().contains(texto.toLowerCase()) ||
                      e["usuario"]!.toLowerCase().contains(
                        texto.toLowerCase(),
                      ) ||
                      e["fecha"]!.toLowerCase().contains(texto.toLowerCase()),
                )
                .toList();
      }
      paginaActual = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    int inicio = paginaActual * filasPorPagina;
    int fin = (inicio + filasPorPagina).clamp(0, filtrados.length);
    List<Map<String, String>> paginados = filtrados.sublist(inicio, fin);

    return BaseLayout(
      bodyContent: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por folio, usuario o fecha',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filtrar,
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Folio")),
                    DataColumn(label: Text("Usuario")),
                    DataColumn(label: Text("Fecha")),
                  ],
                  rows:
                      paginados.map((row) {
                        return DataRow(
                          cells: [
                            DataCell(Text(row["folio"]!)),
                            DataCell(Text(row["usuario"]!)),
                            DataCell(Text(row["fecha"]!)),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed:
                      paginaActual > 0
                          ? () => setState(() => paginaActual--)
                          : null,
                  child: Text('Anterior'),
                ),
                SizedBox(width: 15),
                Text('Página ${paginaActual + 1}'),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed:
                      (paginaActual + 1) * filasPorPagina < filtrados.length
                          ? () => setState(() => paginaActual++)
                          : null,
                  child: Text('Siguiente'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
