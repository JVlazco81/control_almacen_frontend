import 'package:flutter/material.dart';
import '../widgets/salida/form_informacion.dart';
import '../widgets/salida/form_productos.dart';
import '../widgets/salida/resumen_totales.dart';
import '../widgets/salida/tabla_espera.dart';
import '../widgets/BaseLayout.dart';
import '../services/auth_service.dart';

class Salidas_Art extends StatefulWidget {
  const Salidas_Art({super.key});

  @override
  _SalidasArtState createState() => _SalidasArtState();
}

class _SalidasArtState extends State<Salidas_Art> {
  @override
  void initState() {
    super.initState();
    _verificarSesion();
  }

  void _verificarSesion() async {
    String? token = await AuthService.getToken();
    if (token == null && mounted) {
      Navigator.of(context).pushReplacementNamed("/");
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
                'Salida de productos del sistema',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              FormularioInformacionSalida(),
              SizedBox(height: 20),
              FormProductosSalida(),
              SizedBox(height: 20),
              ResumenTotalesSalida(),
              SizedBox(height: 20),
              TablaEsperaSalida(),
            ],
          ),
        ),
      ),
    );
  }
}
