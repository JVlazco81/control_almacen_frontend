import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/login.dart';

class BaseLayout extends StatefulWidget {
  final Widget bodyContent;

  const BaseLayout({super.key, required this.bodyContent});

  @override
  _BaseLayoutState createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  bool _isValeExpanded = false;
  String _selectedMenu = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String? currentRoute = ModalRoute.of(context)?.settings.name;

    setState(() {
      switch (currentRoute) {
        case '/existencias':
          _selectedMenu = "Existencias";
          break;
        case '/entrada':
          _selectedMenu = "Entrada";
          break;
        case '/salida':
          _selectedMenu = "Salida";
          break;
        case '/historial':
          _selectedMenu = "Historial de Vales";
          break;
        case '/usuarios':
          _selectedMenu = "Gestión de Usuarios";
          break;
        default:
          _selectedMenu = "";
      }
    });
  }

  //MOSTRAR EL DIÁLOGO DE CONFIRMACIÓN
  void _confirmarLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return AlertDialog(
              title: const Text("Confirmación"),
              content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
              actions: [
                TextButton(
                  onPressed:
                      authProvider.isLoading
                          ? null
                          : () {
                            Navigator.of(context).pop();
                          },
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed:
                      authProvider.isLoading
                          ? null
                          : () async {
                            await authProvider.logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                              (route) =>
                                  false, // Elimina todas las rutas anteriores
                            );
                          },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child:
                      authProvider.isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            "Cerrar sesión",
                            style: TextStyle(color: Colors.white),
                          ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // BOTÓN DE CERRAR SESIÓN
  Widget _buildLogoutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Cerrar Sesión'),
      onTap: () {
        _confirmarLogout(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        return Scaffold(
          key: _scaffoldKey,
          appBar:
              isMobile
                  ? AppBar(
                    title: const Text('Menú'),
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  )
                  : null,
          drawer: isMobile ? _buildDrawer(context) : null,
          body: Row(
            children: [
              if (!isMobile) _buildSidebar(),
              Expanded(
                child: Column(
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.all(20),
                    //   width: double.infinity,
                    //   color: const Color.fromARGB(255, 100, 18, 9),
                    //   child: const Text(
                    //     'HEAD',
                    //     style: TextStyle(
                    //       fontSize: 24,
                    //       fontWeight: FontWeight.bold,
                    //       color: Color(0xFFFFFFFF),
                    //     ),
                    //   ),
                    // ),
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
      child: Column(
        children: [
          _buildDrawerHeader(),
          _buildDrawerTile(
            context,
            'Existencias',
            Icons.inventory,
            '/existencias',
          ),
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
            _buildDrawerTile(context, 'Entrada', Icons.input, '/entrada'),
            _buildDrawerTile(context, 'Salida', Icons.output, '/salida'),
          ],
          _buildDrawerTile(
            context,
            'Historial de Vales',
            Icons.history,
            '/historial',
          ),
          if (Provider.of<AuthProvider>(context, listen: false).currentUser?.idRol == 2)
            _buildDrawerTile(
              context,
              'Gestión de Usuarios',
              Icons.people,
              '/usuarios',
            ),
          const Spacer(), // Esto empuja el icono de logout hacia abajo
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              _confirmarLogout(context);
            },
          ), // Logout
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 270,
      color: Colors.grey[900],
      child: Column(
        children: [
          _buildSidebarHeader(),
          _buildSidebarOption(Icons.inventory, 'Existencias', '/existencias'),
          _buildSidebarExpandableOption(
            Icons.assignment,
            'Gestión de Productos',
            [
              _buildSidebarOption(Icons.input, 'Entrada', '/entrada'),
              _buildSidebarOption(Icons.output, 'Salida', '/salida'),
            ],
          ),
          _buildSidebarOption(
            Icons.history,
            'Historial de Vales',
            '/historial',
          ),
          if (Provider.of<AuthProvider>(context, listen: false).currentUser?.idRol == 2)
            _buildSidebarOption(Icons.people, 'Gestión de Usuarios', '/usuarios'),

          const Spacer(), // Empuja el botón de logout al final
          _buildLogoutTile(context), // Botón de Logout
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      color: const Color.fromARGB(255, 100, 18, 9),
      child: Column(
        children: [
          Image.asset(
            'assets/images/DropboxLogo.png',
            width: 100,
            height: 100,
            color: Colors.white,
            colorBlendMode: BlendMode.srcIn,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          const Text(
            'Control Almacén',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarOption(IconData icon, String title, String route) {
    bool isSelected = _selectedMenu == title;
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color.fromARGB(255, 145, 120, 37)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey[400]),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[400],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarExpandableOption(
    IconData icon,
    String title,
    List<Widget> children,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isValeExpanded = !_isValeExpanded;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.grey[400]),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Spacer(),
                Icon(
                  _isValeExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
        if (_isValeExpanded) ...children,
      ],
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(color: Colors.deepPurple[700]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.store, size: 50, color: Colors.white),
          SizedBox(height: 10),
          Text(
            'Almacén Control',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(title),
      selected: _selectedMenu == title,
      selectedTileColor: Colors.deepPurple[300],
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
