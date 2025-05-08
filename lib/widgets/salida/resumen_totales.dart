import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/salidas_provider.dart';

class ResumenTotalesSalida extends StatelessWidget {
  const ResumenTotalesSalida({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SalidasProvider>(context);

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Total de artículos en espera: ${provider.calcularTotalArticulos()}',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
