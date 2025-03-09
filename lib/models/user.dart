class User {
  final String primerNombre;
  final String segundoNombre;
  final String password;

  User({
    required this.primerNombre,
    required this.segundoNombre,
    required this.password,
  });

  // Convertir a JSON para enviarlo en la petición
  Map<String, dynamic> toJson() {
    return {
      "primer_nombre": primerNombre,
      "segundo_nombre": segundoNombre,
      "password": password,
    };
  }
}
