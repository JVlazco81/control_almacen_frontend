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

  Future<void> cargarUsuarios() async {
    _isLoading = true;
    notifyListeners();

    try {
      final nuevosUsuarios = await UsuariosService.obtenerUsuarios();
      _usuarios
        ..clear()
        ..addAll(nuevosUsuarios);
    } catch (e) {
      debugPrint("Error al cargar usuarios: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> eliminarUsuario(int idUsuario) async {
    _isLoading = true;
    notifyListeners();

    try {
      await UsuariosService.eliminarUsuario(idUsuario);
      _usuarios.removeWhere((user) => user.idUsuario == idUsuario);
    } catch (e) {
      debugPrint("Error al eliminar usuario: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> actualizarUsuario(int idUsuario, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await UsuariosService.actualizarUsuario(idUsuario, data);
      final index = _usuarios.indexWhere((u) => u.idUsuario == idUsuario);
      if (index != -1) {
        // Re-fetch the updated user to refresh the list
        final updatedUser = await UsuariosService.obtenerUsuarioPorId(idUsuario);
        _usuarios[index] = updatedUser;
      }
    } catch (e) {
      debugPrint("Error al actualizar usuario: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User> obtenerUsuarioPorId(int idUsuario) async {
    try {
      return await UsuariosService.obtenerUsuarioPorId(idUsuario);
    } catch (e) {
      debugPrint("Error al obtener usuario por ID: $e");
      rethrow;
    }
  }
}