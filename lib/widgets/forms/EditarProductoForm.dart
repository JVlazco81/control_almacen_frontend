import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/producto.dart';
import '../../providers/inventario_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

class EditarProductoForm extends StatefulWidget {
  final Producto producto;

  const EditarProductoForm({Key? key, required this.producto})
    : super(key: key);

  @override
  State<EditarProductoForm> createState() => _EditarProductoFormState();
}

class _EditarProductoFormState extends State<EditarProductoForm> {
  final _formKey = GlobalKey<FormState>();
  bool _guardando = false;

  late TextEditingController descripcionController;
  late TextEditingController marcaController;
  late TextEditingController cantidadController;
  late TextEditingController precioController;
  late TextEditingController totalController;

  String? clasificacionSeleccionada;
  Map<String, dynamic>? unidadSeleccionada;

  final List<Map<String, dynamic>> unidades = [
    {"id": 1, "nombre": "Caja"},
    {"id": 2, "nombre": "Paquete"},
    {"id": 3, "nombre": "Pieza"},
  ];

  final Map<String, String> clasificaciones = {
    "2111": "Materiales, útiles y equipos menores de oficina",
    "2121": "Materiales y útiles de impresión y reproducción",
    "2131": "Material estadístico y geográfico",
    "2141": "Materiales, útiles, equipos y bienes informáticos",
    "2151": "Material impreso e información digital",
    "2161": "Material de limpieza",
    "2171": "Materiales y útiles de enseñanza",
    "2181": "Materiales para registro de bienes y personas",
    "2211": "Productos alimenticios para personas",
    "2221": "Productos alimenticios para animales",
    // ... puedes completar el resto
  };

  @override
  void initState() {
    super.initState();
    descripcionController = TextEditingController(
      text: widget.producto.descripcion,
    );
    marcaController = TextEditingController(text: widget.producto.marcaAutor);
    cantidadController = TextEditingController(
      text: widget.producto.existencias.toString(),
    );
    precioController = TextEditingController(
      text: widget.producto.costoPorUnidad.toStringAsFixed(2),
    );
    totalController = TextEditingController(
      text: (widget.producto.existencias * widget.producto.costoPorUnidad)
          .toStringAsFixed(2),
    );

    clasificacionSeleccionada = widget.producto.claveProducto.toString();

    unidadSeleccionada = unidades.firstWhere(
      (u) => u['nombre'].toLowerCase() == widget.producto.unidad.toLowerCase(),
      orElse: () => unidades[0],
    );
  }

  @override
  void dispose() {
    descripcionController.dispose();
    marcaController.dispose();
    cantidadController.dispose();
    precioController.dispose();
    totalController.dispose();
    super.dispose();
  }

  void calcularTotal() {
    final cantidad = double.tryParse(cantidadController.text) ?? 0;
    final precio = double.tryParse(precioController.text) ?? 0;
    totalController.text = (cantidad * precio).toStringAsFixed(2);
  }

  Future<void> guardarCambios() async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('¿Guardar cambios?'),
            content: Text('¿Deseas actualizar la información del producto?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Guardar'),
              ),
            ],
          ),
    );

    if (confirmacion != true) return;

    setState(() => _guardando = true);
    final provider = Provider.of<InventarioProvider>(context, listen: false);

    final datos = {
      "descripcion_producto": descripcionController.text.trim(),
      "marca": marcaController.text.trim(),
      "cantidad": int.tryParse(cantidadController.text.trim()) ?? 0,
      "codigo": int.parse(clasificacionSeleccionada!),
      "precio": double.tryParse(precioController.text.trim()) ?? 0,
      "id_unidad": unidadSeleccionada!['id'],
    };

    try {
      await provider.actualizarProducto(widget.producto.num, datos);
      await provider.cargarInventario();

      // ✅ Mostrar alerta de éxito
      if (mounted) {
        await showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text('¡Actualización exitosa!'),
                content: Text('El producto se actualizó correctamente.'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Aceptar'),
                  ),
                ],
              ),
        );

        Navigator.pushReplacementNamed(context, '/existencias');
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text('Error'),
                content: Text('❌ Hubo un error al actualizar el producto.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cerrar'),
                  ),
                ],
              ),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Modificar producto'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: 'Nombre/Descripción'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo obligatorio'
                            : null,
              ),
              TextFormField(
                controller: marcaController,
                decoration: InputDecoration(labelText: 'Marca'),
              ),

              DropdownSearch<String>(
                items:
                    clasificaciones.entries
                        .map((e) => "${e.key} - ${e.value}")
                        .toList(),
                selectedItem:
                    "${clasificacionSeleccionada!} - ${clasificaciones[clasificacionSeleccionada]!}",
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Clasificación',
                  ),
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(
                    maxHeight: 300,
                  ), // altura del popup
                ),
                onChanged: (val) {
                  final key = val!.split(" - ").first;
                  setState(() => clasificacionSeleccionada = key);
                },
              ),

              DropdownButtonFormField<Map<String, dynamic>>(
                value: unidadSeleccionada,
                decoration: InputDecoration(labelText: 'Unidad de medida'),
                items:
                    unidades
                        .map(
                          (u) => DropdownMenuItem(
                            value: u,
                            child: Text(u['nombre']),
                          ),
                        )
                        .toList(),
                onChanged: (val) => setState(() => unidadSeleccionada = val),
              ),
              TextFormField(
                controller: cantidadController,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => calcularTotal(),
              ),
              TextFormField(
                controller: precioController,
                decoration: InputDecoration(labelText: 'Precio unitario'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                onChanged: (_) => calcularTotal(),
              ),
              TextFormField(
                controller: totalController,
                enabled: false,
                decoration: InputDecoration(labelText: 'Total'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed:
              _guardando
                  ? null
                  : () {
                    if (_formKey.currentState!.validate()) {
                      guardarCambios();
                    }
                  },
          child:
              _guardando
                  ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : Text('Guardar'),
        ),
      ],
    );
  }
}
