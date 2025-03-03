import 'package:flutter/material.dart';
import 'package:control_almacen_frontend/widgets/BaseLayout.dart';

class Salidas_Art extends StatelessWidget {
  const Salidas_Art({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(bodyContent: Center(child: Text('Vista de Salida')));
  }
}
