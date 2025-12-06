// lib/services/user_service.dart
//Service ini yang akan: baca data user dari SharedPreferences, menghapus data saat logout
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserService {
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getInt('user_id');
    final username = prefs.getString('username');
    final email = prefs.getString('email');
    // nanti bisa tambahkan createdAt kalau kamu simpan saat login

    if (id == null || username == null || email == null) {
      return null;
    }

    return UserModel(
      id: id,
      username: username,
      email: email,
      // contoh dummy sementara:
      createdAt: 'Bergabung: 02 Desember 2025',
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
