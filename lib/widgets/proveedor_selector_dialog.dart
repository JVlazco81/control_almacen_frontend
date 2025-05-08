import 'package:flutter/material.dart';
import '../services/entrada_service.dart';

class ProveedorSelectorDialog extends StatefulWidget {
  const ProveedorSelectorDialog({super.key});

  @override
  _ProveedorSelectorDialogState createState() => _ProveedorSelectorDialogState();
}

class _ProveedorSelectorDialogState extends State<ProveedorSelectorDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _resultados = [];
  bool _isLoading = false;

  void _buscar() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final resultados = await EntradaService.buscarProveedores(_searchController.text);
      setState(() {
        _resultados = resultados;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar proveedores')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Buscar Proveedor'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Buscar',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: _buscar,
              ),
            ),
            onSubmitted: (_) => _buscar(),
          ),
          SizedBox(height: 10),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: 300,
                  width: double.maxFinite,
                  child: _resultados.isEmpty
                      ? Center(child: Text('No hay resultados'))
                      : ListView.builder(
                          itemCount: _resultados.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_resultados[index]),
                              onTap: () {
                                Navigator.of(context).pop(_resultados[index]);
                              },
                            );
                          },
                        ),
                ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Cerrar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}