// Flutter & Third-party packages
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

// Providers
import 'package:control_almacen_frontend/providers/auth_provider.dart';
import 'package:control_almacen_frontend/providers/entradas_provider.dart';
import 'package:control_almacen_frontend/providers/historial_cambios_provider.dart';
import 'package:control_almacen_frontend/providers/historial_entradas_provider.dart';
import 'package:control_almacen_frontend/providers/historial_salidas_provider.dart';
import 'package:control_almacen_frontend/providers/inventario_provider.dart';
import 'package:control_almacen_frontend/providers/salidas_provider.dart';
import 'package:control_almacen_frontend/providers/usuarios_provider.dart';

// Screens
import 'package:control_almacen_frontend/screens/bienvenida.dart';
import 'package:control_almacen_frontend/screens/entradas_art.dart';
import 'package:control_almacen_frontend/screens/existencias_view.dart';
import 'package:control_almacen_frontend/screens/gestion_usuarios.dart';
import 'package:control_almacen_frontend/screens/historial_cambios_view.dart';
import 'package:control_almacen_frontend/screens/historial_entradas_view.dart';
import 'package:control_almacen_frontend/screens/historial_salidas_view.dart';
import 'package:control_almacen_frontend/screens/historial_view.dart';
import 'package:control_almacen_frontend/screens/login.dart';
import 'package:control_almacen_frontend/screens/salidas_art.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: "assets/env/.env");
  } catch (e) {
    
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EntradasProvider()),
        ChangeNotifierProvider(create: (_) => SalidasProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => InventarioProvider()),
        ChangeNotifierProvider(create: (_) => UsuariosProvider()),
        ChangeNotifierProvider(create: (_) => HistorialCambiosProvider()),
        ChangeNotifierProvider(create: (_) => HistorialEntradasProvider()),
        ChangeNotifierProvider(create: (_) => HistorialSalidasProvider()),
      ],
      child: const MyApp(),
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
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/bienvenida': (context) => Bienvenida(),
        '/existencias': (context) => Existencias_View(),
        '/historial': (context) => Historial_View(),
        '/entrada': (context) => Entradas_Art(),
        '/salida': (context) => Salidas_Art(),
        '/usuarios': (context) => Gestion_Usuarios(),
        '/historial-cambios': (context) => const HistorialCambiosView(),
        '/historial-entradas': (context) => HistorialEntradasView(),
        '/historial-salidas': (context) => HistorialSalidasView(),
      },
    );
  }
}