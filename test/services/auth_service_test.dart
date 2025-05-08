import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:control_almacen_frontend/models/user.dart';
import 'package:control_almacen_frontend/services/auth_service.dart';
import 'auth_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService', () {
    late MockClient mockClient;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      mockClient = MockClient();
      prefs = await SharedPreferences.getInstance();
    });

    test('login returns true on status 200 and saves data', () async {
      final mockResponse = {
        "message": "Login exitoso",
        "token": "6|xFil5QS2jTofDic3nInOYqTcdiIGrNhgKeGVZHcha47c38ee",
        "user": {
          "id_usuario": 1,
          "id_rol": 2,
          "primer_nombre": "Juan",
          "segundo_nombre": "Carlos",
          "primer_apellido": "Lozano",
          "segundo_apellido": "Vergara",
          "deleted_at": null
        }
      };

      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final user = User(
        idUsuario: 1,
        idRol: 2,
        primerNombre: 'Juan',
        segundoNombre: 'Carlos',
        primerApellido: 'Lozano',
        segundoApellido: 'Vergara',
      );

      final result = await AuthService.login(
        user,
        'Pass_123',
        client: mockClient,
        baseUrl: 'http://localhost/api', // <-- evita dotenv
      );

      expect(result, true);
      expect(prefs.getString('access_token'), mockResponse['token']);
    });

    test('getToken retrieves stored token', () async {
      await prefs.setString("access_token", "token_test");
      final token = await AuthService.getToken();
      expect(token, "token_test");
    });

    test('getUser retrieves stored user', () async {
      final userJson = jsonEncode({
        "id_usuario": 1,
        "id_rol": 2,
        "primer_nombre": "Luis",
        "segundo_nombre": "Andrés",
        "primer_apellido": "Pérez",
        "segundo_apellido": "Martínez"
      });

      await prefs.setString("user_data", userJson);

      final user = await AuthService.getUser();
      expect(user?.primerNombre, 'Luis');
    });

    test('logout clears token and user', () async {
      await prefs.setString("access_token", "abc123");
      await prefs.setString("user_data", '{"id_usuario":1}');

      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('', 200));

      await AuthService.logout(
        client: mockClient,
        baseUrl: 'http://localhost/api', // <-- evita dotenv
      );

      expect(prefs.getString("access_token"), null);
      expect(prefs.getString("user_data"), null);
    });
  });
}