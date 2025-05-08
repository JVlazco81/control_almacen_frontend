import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/usuarios_provider.dart';

class EditarUsuarioForm extends StatefulWidget {
  final User usuario;

  const EditarUsuarioForm({super.key, required this.usuario});

  @override
  State<EditarUsuarioForm> createState() => _EditarUsuarioFormState();
}

class _EditarUsuarioFormState extends State<EditarUsuarioForm> {
  final _formKey = GlobalKey<FormState>();
  bool _guardando = false;

  late TextEditingController primerNombreController;
  late TextEditingController segundoNombreController;
  late TextEditingController primerApellidoController;
  late TextEditingController segundoApellidoController;
  late TextEditingController passwordController;
  int? rolSeleccionado;

  final Map<int, String> roles = {
    1: 'Almacenista',
    2: 'Director',
  };

  @override
  void initState() {
    super.initState();
    primerNombreController = TextEditingController(text: widget.usuario.primerNombre);
    segundoNombreController = TextEditingController(text: widget.usuario.segundoNombre);
    primerApellidoController = TextEditingController(text: widget.usuario.primerApellido);
    segundoApellidoController = TextEditingController(text: widget.usuario.segundoApellido);
    passwordController = TextEditingController();
    rolSeleccionado = widget.usuario.idRol;
  }

  @override
  void dispose() {
    primerNombreController.dispose();
    segundoNombreController.dispose();
    primerApellidoController.dispose();
    segundoApellidoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> guardarCambios() async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Guardar cambios?'),
        content: const Text('¿Deseas actualizar la información del usuario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (confirmacion != true) return;

    setState(() => _guardando = true);

    final provider = Provider.of<UsuariosProvider>(context, listen: false);
    final data = {
      "id_rol": rolSeleccionado,
      "primer_nombre": primerNombreController.text.trim(),
      "segundo_nombre": segundoNombreController.text.trim(),
      "primer_apellido": primerApellidoController.text.trim(),
      "segundo_apellido": segundoApellidoController.text.trim(),
    };
    if (passwordController.text.trim().isNotEmpty) {
      data["usuario_password"] = passwordController.text.trim();
    }

    try {
      await provider.actualizarUsuario(widget.usuario.idUsuario, data);
      await provider.cargarUsuarios();

      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('¡Actualización exitosa!'),
            content: const Text('El usuario se actualizó correctamente.'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
        Navigator.pop(context); // Cerrar el form
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Text('Hubo un error al actualizar el usuario.\n$e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cerrar'),
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
      title: const Text('Modificar usuario'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: primerNombreController,
                decoration: const InputDecoration(labelText: 'Primer Nombre'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: segundoNombreController,
                decoration: const InputDecoration(labelText: 'Segundo Nombre'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: primerApellidoController,
                decoration: const InputDecoration(labelText: 'Primer Apellido'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: segundoApellidoController,
                decoration: const InputDecoration(labelText: 'Segundo Apellido'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: rolSeleccionado,
                decoration: const InputDecoration(labelText: 'Rol'),
                items: roles.entries.map(
                  (entry) => DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  ),
                ).toList(),
                onChanged: (val) => setState(() {
                  rolSeleccionado = val;
                }),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nueva contraseña (opcional)',
                  helperText: 'Debe tener al menos 8 caracteres, 1 mayúscula y 1 carácter especial.',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardando
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    guardarCambios();
                  }
                },
          child: _guardando
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}