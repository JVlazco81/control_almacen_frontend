import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/usuarios_service.dart';

class UsuariosProvider extends ChangeNotifier {
  final List<User> _usuarios = [];
  bool _isLoading = false;

  List<User> get usuarios => _usuarios;
  bool get isLoading => _isLoading;

  Future<void> registrarNuevoUsuario({
    required int idRol,
    required String primerNombre,
    required String segundoNombre,
    required String primerApellido,
    required String segundoApellido,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      User nuevo = await UsuariosService.registrarUsuario(
        idRol: idRol,
        primerNombre: primerNombre,
        segundoNombre: segundoNombre,
        primerApellido: primerApellido,
        segundoApellido: segundoApellido,
        password: password,
      );
      _usuarios.add(nuevo);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}