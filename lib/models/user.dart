class User {
  final int idUsuario;
  final int idRol;
  final String primerNombre;
  final String segundoNombre;
  final String primerApellido;
  final String segundoApellido;

  User({
    required this.idUsuario,
    required this.idRol,
    required this.primerNombre,
    required this.segundoNombre,
    required this.primerApellido,
    required this.segundoApellido,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUsuario: json["id_usuario"],
      idRol: json["id_rol"],
      primerNombre: json["primer_nombre"],
      segundoNombre: json["segundo_nombre"],
      primerApellido: json["primer_apellido"],
      segundoApellido: json["segundo_apellido"],
    );
  }

  Map<String, dynamic> toJsonLogin(String password) {
    return {
      "primer_nombre": primerNombre,
      "primer_apellido": primerApellido,
      "usuario_password": password,
    };
  }
}