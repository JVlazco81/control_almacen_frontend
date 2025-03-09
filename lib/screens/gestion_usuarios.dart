import 'package:flutter/material.dart';
import 'package:control_almacen_frontend/widgets/BaseLayout.dart';

class Gestion_Usuarios extends StatefulWidget {
  const Gestion_Usuarios({super.key});

  @override
  _Gestion_UsuariosState createState() => _Gestion_UsuariosState();
}

class _Gestion_UsuariosState extends State<Gestion_Usuarios> {
  final TextEditingController primerNombreController = TextEditingController();
  final TextEditingController segundoNombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController segundoApellidoController =
      TextEditingController();
  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  String rolSeleccionado = 'Almacenista';

  List<Map<String, String>> usuariosRegistrados = [];

  void _agregarUsuario() {
    if (primerNombreController.text.isNotEmpty &&
        apellidoController.text.isNotEmpty &&
        contrasenaController.text.isNotEmpty) {
      setState(() {
        usuariosRegistrados.add({
          "nombre":
              "${primerNombreController.text} ${segundoNombreController.text} ${apellidoController.text} ${segundoApellidoController.text}",
          "matricula": matriculaController.text,
          "rol": rolSeleccionado,
        });
      });
      _limpiarCampos();
    }
  }

  void _limpiarCampos() {
    primerNombreController.clear();
    segundoNombreController.clear();
    apellidoController.clear();
    segundoApellidoController.clear();
    matriculaController.clear();
    contrasenaController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      bodyContent: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gestión de Usuarios',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Sección de Registro de Usuarios
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Registrar nuevo usuario',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: primerNombreController,
                            decoration: const InputDecoration(
                              labelText: 'Primer Nombre *',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: segundoNombreController,
                            decoration: const InputDecoration(
                              labelText: 'Segundo Nombre (Opcional)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: apellidoController,
                            decoration: const InputDecoration(
                              labelText: 'Apellido *',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: segundoApellidoController,
                            decoration: const InputDecoration(
                              labelText: 'Segundo Apellido (Opcional)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: matriculaController,
                            decoration: const InputDecoration(
                              labelText: 'Matrícula / Núm. Empleado',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: contrasenaController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña *',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: rolSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Rol de usuario',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          ['Director', 'Almacenista']
                              .map(
                                (rol) => DropdownMenuItem(
                                  value: rol,
                                  child: Text(rol),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          rolSeleccionado = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _limpiarCampos,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red[100],
                          ),
                          child: const Text(
                            'Limpiar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _agregarUsuario,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Ingresar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Lista de Usuarios Registrados
            Expanded(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Usuarios Registrados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child:
                            usuariosRegistrados.isEmpty
                                ? const Center(
                                  child: Text(
                                    "No hay usuarios registrados.",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: usuariosRegistrados.length,
                                  itemBuilder: (context, index) {
                                    final usuario = usuariosRegistrados[index];
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 2,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blueAccent,
                                          child: Text(usuario["nombre"]![0]),
                                        ),
                                        title: Text(usuario["nombre"]!),
                                        subtitle: Text(
                                          usuario["rol"]!,
                                          style: TextStyle(
                                            color:
                                                usuario["rol"] == "Director"
                                                    ? Colors.red
                                                    : Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        trailing: const Icon(Icons.more_vert),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
