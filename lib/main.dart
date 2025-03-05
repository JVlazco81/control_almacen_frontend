import 'package:control_almacen_frontend/screens/entradas_art.dart';
import 'package:control_almacen_frontend/screens/existencias_view.dart';
import 'package:control_almacen_frontend/screens/historial_view.dart';
import 'package:control_almacen_frontend/screens/login.dart';
import 'package:control_almacen_frontend/screens/salidas_art.dart';
import 'package:flutter/material.dart';
import 'package:control_almacen_frontend/screens/bienvenida.dart';

/*void main() {
  runApp(
    MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MyApp(),
    ),
  );
} */

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Aplicación Web',
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
      },
      //home: HomeScreen(),
    );
  }
}
