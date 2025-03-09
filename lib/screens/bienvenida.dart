import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:control_almacen_frontend/widgets/BaseLayout.dart';

class Bienvenida extends StatelessWidget {
  const Bienvenida({super.key});

  String obtenerNombreRol(int idRol) {
    switch (idRol) {
      case 1:
        return "Almacenista";
      case 2:
        return "Director";
      default:
        return "Usuario";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos las dimensiones de la pantalla para hacer ajustes responsivos
    var screenWidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return BaseLayout(
      // Aquí pasas el contenido de la vista Bienvenida como un widget al Body del BaseLayout
      bodyContent: Column(
        children: [
          // Body Content (Occupies remaining space)
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color.fromARGB(
                255,
                100,
                18,
                9,
              ), // Fondo rojo como el diseño
              child: Stack(
                children: [
                  // Imagen de fondo
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/FondoCampeche.png', // Cambia por la ruta de tu imagen
                      fit:
                          BoxFit
                              .cover, // Ajusta la imagen para cubrir todo el espacio
                    ),
                  ),

                  // Sección de texto y logo en la misma fila
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Textos de bienvenida
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user != null
                                    ? "Buenos días, ${obtenerNombreRol(user.idRol)} ${user.primerNombre}"
                                    : "Cargando usuario...",
                                style: TextStyle(
                                  fontSize:
                                      screenWidth *
                                      0.05, // Ajuste dinámico del tamaño de la fuente
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Logo (Imagen en lugar del cuadro gris)
                        Flexible(
                          child: Image.asset(
                            'assets/images/InstitutoLogo.png', // Reemplaza con la ruta de tu imagen
                            width:
                                screenWidth *
                                0.3, // Ajuste dinámico del tamaño de la imagen
                            height: screenWidth * 0.3,
                            fit:
                                BoxFit
                                    .contain, // Ajusta la imagen dentro del espacio
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
