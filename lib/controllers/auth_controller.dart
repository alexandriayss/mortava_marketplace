// lib/controllers/auth_controller.dart
import '../services/auth_service.dart';

class AuthController {
  final AuthService _service = AuthService();

  Future<void> login(String identifier, String password) async {
    if (identifier.isEmpty || password.isEmpty) {
      throw Exception('Identifier dan password wajib diisi');
    }

    await _service.login(
      identifier: identifier,
      password: password,
    );
  }
}
