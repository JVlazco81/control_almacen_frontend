import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'bienvenida.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child:
            isSmallScreen
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [_FormContent()],
                )
                : Container(
                  padding: const EdgeInsets.all(70.0),
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            'assets/images/DropboxLogo.png',
                            width: 150,
                            height: 150,
                            color: Colors.black,
                            colorBlendMode: BlendMode.srcIn,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const Expanded(child: Center(child: _FormContent())),
                    ],
                  ),
                ),
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese su contraseña';
    }
    if (value.length < 8) {
      return 'Debe tener al menos 8 caracteres';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Debe contener al menos una letra mayúscula';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Debe contener al menos un número';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_/]').hasMatch(value)) {
      return 'Debe contener al menos un carácter especial (!@#\$%^&*_/)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: matriculaController,
              decoration: const InputDecoration(
                labelText: 'Matrícula',
                hintText: 'Ingrese su matrícula',
                prefixIcon: Icon(Icons.badge_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: !_isPasswordVisible,
              validator: _validatePassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                hintText: 'Ingrese su contraseña',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
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
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  String nombreCompleto = matriculaController.text;
                  List<String> partes = nombreCompleto.split(".");

                  if (partes.length < 2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Formato incorrecto de matrícula"),
                      ),
                    );
                    return;
                  }

                  String primerNombre = partes[0];
                  String primerApellido = partes[1];
                  String password = passwordController.text;

                  await authProvider.login(
                    primerNombre,
                    primerApellido,
                    password,
                  );

                  if (authProvider.isAuthenticated) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Bienvenida(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Error en el inicio de sesión"),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
