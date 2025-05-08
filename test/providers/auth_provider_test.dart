import 'package:flutter_test/flutter_test.dart';
import 'package:control_almacen_frontend/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthProvider', () {
    late AuthProvider provider;

    setUp(() {
      // Inicializar preferencias simuladas
      SharedPreferences.setMockInitialValues({});
      provider = AuthProvider();
    });

    test('initial state is unauthenticated and not loading', () {
      expect(provider.isAuthenticated, false);
      expect(provider.isLoading, false);
      expect(provider.currentUser, null);
    });

    test('logout resets state', () async {
      provider.isAuthenticated = true;
      provider.currentUser = null;
      provider.isLoading = true;

      await provider.logout();

      expect(provider.isAuthenticated, false);
      expect(provider.currentUser, null);
      expect(provider.isLoading, false);
    });
  });
}