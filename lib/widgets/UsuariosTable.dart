import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/usuarios_provider.dart';
import '../widgets/Forms/EditarUsuarioForm.dart';

class UsuariosTable extends StatefulWidget {
  const UsuariosTable({super.key});

  @override
  State<UsuariosTable> createState() => _UsuariosTableState();
}

class _UsuariosTableState extends State<UsuariosTable> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<UsuariosProvider>(context, listen: false);
      await provider.cargarUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsuariosProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.usuarios.isEmpty) {
          return const Center(child: Text('No hay usuarios registrados.'));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
            columns: const [
              DataColumn(label: Text('Rol')),
              DataColumn(label: Text('Primer Nombre')),
              DataColumn(label: Text('Segundo Nombre')),
              DataColumn(label: Text('Primer Apellido')),
              DataColumn(label: Text('Segundo Apellido')),
              DataColumn(label: Text('Opciones')),
            ],
            rows: provider.usuarios.map((usuario) {
              String rol = usuario.idRol == 2 ? 'Director' : 'Almacenista';
              return DataRow(
                cells: [
                  DataCell(Text(rol)),
                  DataCell(Text(usuario.primerNombre)),
                  DataCell(Text(usuario.segundoNombre)),
                  DataCell(Text(usuario.primerApellido)),
                  DataCell(Text(usuario.segundoApellido)),
                  DataCell(
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'actualizar',
                          child: Row(
                            children: const [
                              Icon(Icons.edit, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Actualizar'),
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
                      onSelected: (value) async {
                        final provider = Provider.of<UsuariosProvider>(context, listen: false);
                        if (value == 'actualizar') {
                          final user = await provider.obtenerUsuarioPorId(usuario.idUsuario);
                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (_) => EditarUsuarioForm(usuario: user),
                            );
                          }
                        }
                        if (value == 'eliminar') {
                          bool confirmar = false;
                          bool _eliminando = false;
                          await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: const Text('¿Eliminar usuario?'),
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
                              await provider.eliminarUsuario(usuario.idUsuario);

                              await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Usuario eliminado'),
                                  content: const Text(
                                    '✅ El usuario ha sido eliminado exitosamente.',
                                  ),
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
                                  content: Text(
                                    'Ocurrió un error al intentar eliminar el usuario.\n$e'
                                  ),
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
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}