import 'package:flutter/material.dart';
import 'package:control_almacen_frontend/widgets/BaseLayout.dart';
import '../widgets/entrada/form_informacion.dart';
import '../widgets/entrada/form_productos.dart';
import '../widgets/entrada/resumen_totales.dart';
import '../widgets/entrada/tabla_espera.dart';
import '../services/auth_service.dart';


class Entradas_Art extends StatefulWidget {
  const Entradas_Art({super.key});

  @override
  _Entradas_ArtState createState() => _Entradas_ArtState();
}

class _Entradas_ArtState extends State<Entradas_Art> {
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

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      bodyContent: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entrada de productos al sistema',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Widget con contenedor del formulario con la informacion general
              FormularioInformacion(),
              
              SizedBox(height: 20),

              // Widget con contenedor del formulario de productos
              FormProductos(),

              SizedBox(height: 20),
              
              // Widget con contenedor del resumen de los totales
              ResumenTotales(),
              
              SizedBox(height: 20),
              
              // Widget con contenedor de la tabla de espera
              TablaEspera()
            ],
          ),
        ),
      ),
    );
  }
}