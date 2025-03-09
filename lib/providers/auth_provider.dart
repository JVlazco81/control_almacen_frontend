import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;

  // Verificar autenticación al iniciar la app
  Future<void> checkAuth() async {
    String? token = await AuthService.getToken();
    isAuthenticated = token != null;
    notifyListeners();
  }

  // Iniciar sesión y actualizar estado
  Future<void> login(String primerNombre, String primerApellido, String password) async {
    User user = User(
      primerNombre: primerNombre,
      primerApellido: primerApellido,
      password: password,
    );

    bool success = await AuthService.login(user);
    if (success) {
      isAuthenticated = true;
      notifyListeners();
    }
  }

  // Cerrar sesión y actualizar estado
  Future<void> logout() async {
    await AuthService.logout();
    isAuthenticated = false;
    notifyListeners();
  }
}