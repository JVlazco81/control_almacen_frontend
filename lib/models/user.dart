class User {
  final int idUsuario;
  final int idRol;
  final String primerNombre;
  final String segundoNombre;
  final String primerApellido;
  final String segundoApellido;
  final String password;

  User({
    required this.idUsuario,
    required this.idRol,
    required this.primerNombre,
    required this.segundoNombre,
    required this.primerApellido,
    required this.segundoApellido,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUsuario: json["id_usuario"],
      idRol: json["id_rol"],
      primerNombre: json["primer_nombre"],
      segundoNombre: json["segundo_nombre"],
      primerApellido: json["primer_apellido"],
      segundoApellido: json["segundo_apellido"],
      password: json["usuario_password"], //  por ahora se guarda por pruebas
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "primer_nombre": primerNombre,
      "primer_apellido": primerApellido,
      "usuario_password": password,
    };
  }
}