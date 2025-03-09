class User {
  final String primerNombre;
  final String primerApellido;
  final String password;

  User({
    required this.primerNombre,
    required this.primerApellido,
    required this.password,
  });

  // Convertir a JSON para enviarlo en la petición
  Map<String, dynamic> toJson() {
    return {
      "primer_nombre": primerNombre,
      "primer_apellido": primerApellido,
      "password": password,
    };
  }
}
