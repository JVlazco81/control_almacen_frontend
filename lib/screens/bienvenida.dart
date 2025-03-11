import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import 'package:control_almacen_frontend/widgets/BaseLayout.dart';
import 'login.dart';

class Bienvenida extends StatefulWidget {
  const Bienvenida({super.key});

  @override
  _BienvenidaState createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {
  @override
  void initState() {
    super.initState();
    _verificarSesion();
  }

  void _verificarSesion() async {
    String? token = await AuthService.getToken();
    if (token == null) {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      }
    }
  }

  String obtenerNombreRol(int idRol) {
    switch (idRol) {
      case 1:
        return "Director";
      case 2:
        return "Almacenista";
      default:
        return "Usuario";
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return BaseLayout(
      bodyContent: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 100, 18, 9),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/FondoCampeche.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user != null
                                    ? "Bienvenido, ${obtenerNombreRol(user.idRol)} ${user.primerNombre}"
                                    : "Cargando usuario...",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Image.asset(
                            'assets/images/InstitutoLogo.png',
                            width: screenWidth * 0.3,
                            height: screenWidth * 0.3,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
