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
        child: isSmallScreen
            ? Column(mainAxisSize: MainAxisSize.min, children: const [_FormContent()])
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
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                hintText: 'Ingrese su contraseña',
                prefixIcon: Icon(Icons.lock_outline_rounded),
                border: OutlineInputBorder(),
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
                  String nombreCompleto = matriculaController.text;
                  List<String> partes = nombreCompleto.split(".");

                  if (partes.length < 2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Formato incorrecto de matrícula")),
                    );
                    return;
                  }

                  String primerNombre = partes[0];
                  String primerApellido = partes[1];
                  String password = passwordController.text;

                  await authProvider.login(primerNombre, primerApellido, password);

                  if (authProvider.isAuthenticated) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Bienvenida()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error en el inicio de sesión")),
                    );
                  }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
