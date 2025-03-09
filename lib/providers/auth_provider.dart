import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  User? currentUser;

  // Verificar autenticación al iniciar la app
  Future<void> checkAuth() async {
    String? token = await AuthService.getToken();
    User? user = await AuthService.getUser();

    if (token != null && user != null) {
      isAuthenticated = true;
      currentUser = user;
    } else {
      isAuthenticated = false;
      currentUser = null;
    }
    notifyListeners();
  }

  // Iniciar sesión y actualizar estado
  Future<void> login(String primerNombre, String primerApellido, String password) async {
    User user = User(
      idUsuario: 0,
      idRol: 0,
      primerNombre: primerNombre,
      segundoNombre: "",
      primerApellido: primerApellido,
      segundoApellido: "",
      password: password,
    );

    bool success = await AuthService.login(user);
    if (success) {
      await checkAuth();
    }
  }

  // Cerrar sesión y actualizar estado
  Future<void> logout() async {
    await AuthService.logout();
    isAuthenticated = false;
    currentUser = null;
    notifyListeners();
  }
}
