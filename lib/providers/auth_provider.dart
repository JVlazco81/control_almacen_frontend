import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  bool isLoading = false; // Nuevo estado para indicar carga
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
    isLoading = true;
    notifyListeners();

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
    
    isLoading = false;
    if (success) {
      await checkAuth();
    }
    notifyListeners();
  }

  // Cerrar sesión y actualizar estado
  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    await AuthService.logout();

    isAuthenticated = false;
    currentUser = null;
    isLoading = false;
    notifyListeners();
  }
}