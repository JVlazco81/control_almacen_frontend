import 'package:flutter/material.dart';
import 'package:control_almacen_frontend/widgets/BaseLayout.dart';

class Entradas_Art extends StatelessWidget {
  const Entradas_Art({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(bodyContent: Center(child: Text('Vista de Entrada')));
  }
}
