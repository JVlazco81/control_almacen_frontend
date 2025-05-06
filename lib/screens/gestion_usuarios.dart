import 'package:flutter/material.dart';
import 'package:control_almacen_frontend/widgets/BaseLayout.dart';
import '../services/auth_service.dart';
import '../providers/usuarios_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/UsuariosTable.dart';

class Gestion_Usuarios extends StatefulWidget {
  const Gestion_Usuarios({super.key});

  @override
  _Gestion_UsuariosState createState() => _Gestion_UsuariosState();
}

class _Gestion_UsuariosState extends State<Gestion_Usuarios> {
  @override
  void initState() {
    super.initState();
    _verificarSesion();
  }

  void _verificarSesion() async {
    String? token = await AuthService.getToken();
    if (token == null) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed("/");
      }
    }
  }

  final TextEditingController primerNombreController = TextEditingController();
  final TextEditingController segundoNombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController segundoApellidoController =
      TextEditingController();
  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  bool _isPasswordVisible = false;
  int rolSeleccionado = 1; // Almacenista por defecto

  final Map<int, String> roles = {
    1: 'Almacenista',
    2: 'Director',
  };

  // Estados de validación
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  void _validatePassword(String value) {
    setState(() {
      _hasMinLength = value.length >= 8;
      _hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
      _hasNumber = RegExp(r'[0-9]').hasMatch(value);
      _hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>_/]').hasMatch(value);
    });
  }

  void _agregarUsuario() async {
    if (_hasMinLength && _hasUppercase && _hasNumber && _hasSpecialChar) {
      try {
        final provider = Provider.of<UsuariosProvider>(context, listen: false);

        await provider.registrarNuevoUsuario(
          idRol: rolSeleccionado,
          primerNombre: primerNombreController.text,
          segundoNombre: segundoNombreController.text,
          primerApellido: apellidoController.text,
          segundoApellido: segundoApellidoController.text,
          password: contrasenaController.text,
        );

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Usuario registrado'),
            content: Text('✅ Usuario creado correctamente.'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Aceptar'),
              ),
            ],
          ),
        );

        _limpiarCampos();
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text('❌ No se pudo registrar el usuario.\n${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cerrar'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _limpiarCampos() {
    primerNombreController.clear();
    segundoNombreController.clear();
    apellidoController.clear();
    segundoApellidoController.clear();
    matriculaController.clear();
    contrasenaController.clear();

    setState(() {
      _hasMinLength = false;
      _hasUppercase = false;
      _hasNumber = false;
      _hasSpecialChar = false;
    });
  }

  List<Map<String, String>> usuariosRegistrados = [];

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
                          child: TextFormField(
                            controller: contrasenaController,
                            obscureText: !_isPasswordVisible,
                            onChanged: _validatePassword,
                            decoration: InputDecoration(
                              labelText: 'Contraseña *',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Indicadores de requisitos de contraseña
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPasswordRequirement(
                          _hasMinLength,
                          "Debe tener al menos 8 caracteres",
                        ),
                        _buildPasswordRequirement(
                          _hasUppercase,
                          "Debe contener al menos una letra mayúscula",
                        ),
                        _buildPasswordRequirement(
                          _hasNumber,
                          "Debe contener al menos un número",
                        ),
                        _buildPasswordRequirement(
                          _hasSpecialChar,
                          "Debe contener al menos un carácter especial (!@#\$%^&*_/)",
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<int>(
                      value: rolSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Rol de usuario',
                        border: OutlineInputBorder(),
                      ),
                      items: roles.entries.map(
                        (entry) => DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      ).toList(),
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
            const SizedBox(height: 30),
            const Text(
              'Lista de Usuarios',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Expanded(
              child: UsuariosTable(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar los requisitos de la contraseña
  Widget _buildPasswordRequirement(bool isValid, String text) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isValid ? Colors.green : Colors.red,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
