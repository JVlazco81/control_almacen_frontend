import 'package:flutter/material.dart';
import 'package:control_almacen_frontend/widgets/BaseLayout.dart';

class Historial_View extends StatelessWidget {
  const Historial_View({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      bodyContent: Container(
        color: Colors.purple, // Cambia el fondo por ejemplo
        child: Center(
          child: Text(
            'Vista de Historial',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
