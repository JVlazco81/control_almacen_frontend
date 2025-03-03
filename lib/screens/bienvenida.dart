import 'package:flutter/material.dart';
import 'package:control_almacen_frontend/widgets/BaseLayout.dart';

class Bienvenida extends StatelessWidget {
  const Bienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos las dimensiones de la pantalla para hacer ajustes responsivos
    var screenWidth = MediaQuery.of(context).size.width;

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
                                'Buenos días,',
                                style: TextStyle(
                                  fontSize:
                                      screenWidth *
                                      0.05, // Ajuste dinámico del tamaño de la fuente
                                  color: Colors.grey[300],
                                ),
                              ),
                              Text(
                                'Director [NOMBRE DEL USUARIO]',
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

                  // Texto en la parte inferior izquierda
                  Positioned(
                    bottom: 30,
                    left: 30,
                    child: Text(
                      'LOGO - NOMBRE DEL SISTEMA',
                      style: TextStyle(fontSize: 24, color: Colors.grey[400]),
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
