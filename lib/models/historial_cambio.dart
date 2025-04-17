import 'dart:convert';

class HistorialCambio {
  final String accion;
  final String usuario;
  final String fecha;
  final Map<String, dynamic>? valorAnterior;
  final Map<String, dynamic>? valorNuevo;

  HistorialCambio({
    required this.accion,
    required this.usuario,
    required this.fecha,
    this.valorAnterior,
    this.valorNuevo,
  });

  factory HistorialCambio.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? decode(dynamic value) {
      if (value == null) return null;
      if (value is Map<String, dynamic>) return value;
      try {
        return jsonDecode(value.toString());
      } catch (_) {
        return null;
      }
    }

    final usuarioMap = json['usuario'] ?? {};
    final nombreCompleto =
        usuarioMap is Map
            ? "${usuarioMap['primer_nombre'] ?? ''} ${usuarioMap['segundo_nombre'] ?? ''} ${usuarioMap['primer_apellido'] ?? ''} ${usuarioMap['segundo_apellido'] ?? ''}"
                .trim()
            : usuarioMap.toString();

    return HistorialCambio(
      accion: json['accion'],
      usuario: nombreCompleto,
      fecha: json['fecha'],
      valorAnterior: decode(json['valor_anterior']),
      valorNuevo: decode(json['valor_nuevo']),
    );
  }
}
