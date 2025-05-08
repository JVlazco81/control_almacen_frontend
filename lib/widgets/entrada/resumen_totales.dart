import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/entradas_provider.dart';

class ResumenTotales extends StatelessWidget {
  const ResumenTotales({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EntradasProvider>(context);

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[200], // Color de fondo sutil
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen de Totales',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: provider.subtotalController,
                  decoration: InputDecoration(
                    labelText: 'Subtotal',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.grey[300],
                    enabled: false,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: provider.ivaController,
                  decoration: InputDecoration(
                    labelText: 'IVA (16%)',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.grey[300],
                    enabled: false,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: provider.totalController,
                  decoration: InputDecoration(
                    labelText: 'Total (con IVA)',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.grey[300],
                    enabled: false,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
