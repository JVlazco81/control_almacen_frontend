import 'package:flutter/material.dart';

/*
Este archivo contiene un widget que implementa un diseño base para la aplicación (Se muestra en todas las vistas sin excepción).
El diseño consta de un Sidebar (Aside de escritorio), que se muestran en pantallas grandes,
y un Drawer (Aside de móviles) y un AppBar (Barra de navegación superiro que permite mostrar el menú de hamburguesa), que se muestran en pantallas pequeñas.
El Sidebar y el Drawer contienen opciones de navegación a las diferentes vistas de la aplicación.
*/

class BaseLayout extends StatefulWidget {
  final Widget bodyContent;

  const BaseLayout({super.key, required this.bodyContent});

  @override
  _BaseLayoutState createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  bool _isValeExpanded = false; // Solo mantenemos la expansión del submenú

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        return Scaffold(
          key: _scaffoldKey,
          // Restauramos el AppBar solo para pantallas móviles
          appBar:
              isMobile
                  ? AppBar(
                    title: const Text('Menú'),
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        _scaffoldKey.currentState
                            ?.openDrawer(); // Abre el Drawer
                      },
                    ),
                  )
                  : null, // No mostramos el AppBar en pantallas grandes
          drawer:
              isMobile
                  ? _buildDrawer(context)
                  : null, // Drawer en pantallas pequeñas

          body: Row(
            children: [
              if (!isMobile)
                _buildSidebar(), // Sidebar solo en pantallas grandes
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      color: const Color.fromARGB(255, 100, 18, 9),
                      child: const Text(
                        'HEAD',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    Expanded(child: widget.bodyContent),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _buildDrawerTile(context, 'existenciasView', Icons.inventory, () {
            setState(() {
              _isValeExpanded = false; // Cierra cualquier submenú desplegado
            });
            Navigator.pushReplacementNamed(context, '/existencias');
            _scaffoldKey.currentState?.closeDrawer();
          }),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Vales'),
            onTap: () {
              setState(() {
                _isValeExpanded = !_isValeExpanded;
              });
            },
          ),
          if (_isValeExpanded) ...[
            _buildDrawerTile(context, 'Entrada', Icons.input, () {
              Navigator.pushReplacementNamed(context, '/entrada');
            }),
            _buildDrawerTile(context, 'Salida', Icons.output, () {
              Navigator.pushReplacementNamed(context, '/salida');
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.grey[850],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildSidebarOption(Icons.inventory, 'Existencias', () {
            setState(() {
              _isValeExpanded = false;
            });
            Navigator.pushReplacementNamed(context, '/existencias');
          }),
          const SizedBox(height: 20),
          _buildSidebarOption(Icons.assignment, 'Gestión de Productos', () {
            setState(() {
              _isValeExpanded = !_isValeExpanded; // Toggle del submenú
            });
          }),
          if (_isValeExpanded) ...[
            const SizedBox(height: 10),
            _buildSidebarOption(Icons.input, 'Entrada', () {
              Navigator.pushReplacementNamed(context, '/entrada');
            }),
            const SizedBox(height: 10),
            _buildSidebarOption(Icons.output, 'Salida', () {
              Navigator.pushReplacementNamed(context, '/salida');
            }),
          ],
          const SizedBox(height: 20),
          _buildSidebarOption(Icons.history, 'Historial de vales', () {
            setState(() {
              _isValeExpanded = false;
            });
            Navigator.pushReplacementNamed(context, '/historial');
          }),
        ],
      ),
    );
  }

  // Esta función crea una opción en el Sidebar con ícono y texto
  Widget _buildSidebarOption(
    IconData icon,
    String title,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  // Esta función crea las opciones del Drawer
  Widget _buildDrawerTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}
