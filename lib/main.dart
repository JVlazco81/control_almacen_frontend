import 'package:control_almacen_frontend/screens/entradas_art.dart';
import 'package:control_almacen_frontend/screens/existencias_view.dart';
import 'package:control_almacen_frontend/screens/gestion_usuarios.dart';
import 'package:control_almacen_frontend/screens/historial_view.dart';
import 'package:control_almacen_frontend/screens/login.dart';
import 'package:control_almacen_frontend/screens/salidas_art.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:control_almacen_frontend/providers/entradas_provider.dart';
import 'package:control_almacen_frontend/screens/bienvenida.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => EntradasProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Control de Almacén',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Definir las rutas para la navegación
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/bienvenida': (context) => Bienvenida(),
        '/existencias': (context) => Existencias_View(),
        '/historial': (context) => Historial_View(),
        '/entrada': (context) => Entradas_Art(),
        '/salida': (context) => Salidas_Art(),
        '/usuarios': (context) => Gestion_Usuarios(),
      },
      //home: HomeScreen(),
    );
  }
}
