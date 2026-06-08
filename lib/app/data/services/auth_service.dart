import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/config/api_config.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dummy_data.dart';
import '../models/user_model.dart';

// Service autentikasi.
// Saat ini menggunakan data dummy. Untuk migrasi ke Supabase,
// ganti isi method-nya dengan panggilan Supabase Auth + Postgres.
// Signature method tetap sama, jadi controller tidak perlu diubah.

class AuthService {
  static const String _sessionKey = 'logged_in_user';

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  SharedPreferences get _prefs => Get.find<SharedPreferences>();

  // ---------------------------------------------------------------------------
  // LOGIN
  // Return null kalau berhasil, atau pesan error kalau gagal.
  // ---------------------------------------------------------------------------
  Future<String?> login(
    String username,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/auth/login.php',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print(response.body);

      final data = jsonDecode(response.body);

      if (data['success'] != true) {
        return data['message'];
      }

      final user = data['user'];

      _currentUser = UserModel(
        username: user['username'],
        role: user['role'],
        namaMeja: user['table_number']?.toString(),
      );

      await _prefs.setString(
        _sessionKey,
        jsonEncode(
          _currentUser!.toJson(),
        ),
      );

      return null;
    } catch (e) {
      print('Login error: $e');
      return 'Tidak dapat terhubung ke server';
    }
  }

  // ---------------------------------------------------------------------------
  // CEK SESSION
  // Dipanggil saat app start untuk tentukan halaman awal.
  // ---------------------------------------------------------------------------
  Future<bool> checkSession() async {
    final raw = _prefs.getString(_sessionKey);
    if (raw == null || raw.isEmpty) {
      return false;
    }

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      _currentUser = UserModel.fromJson(json);
      return true;
    } catch (_) {
      // Data corrupt — bersihkan supaya tidak nyangkut
      await _prefs.remove(_sessionKey);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // VERIFIKASI PASSWORD
  // Dipakai untuk konfirmasi logout (user memasukkan ulang password).
  // Saat migrasi Supabase, ganti dengan re-authentication (signInWithPassword
  // memakai email/username user yang sedang login).
  // ---------------------------------------------------------------------------
  Future<bool> verifyPassword(
    String password,
  ) async {
    try {
      print("USERNAME = ${_currentUser?.username}");
      print("PASSWORD = $password");
      final response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/auth/verify_password.php',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': _currentUser?.username,
          'password': password,
        }),
      );

      print(response.body);
      print("VERIFY RESPONSE = ${response.body}");

      final data = jsonDecode(response.body);

      return data['success'] == true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------------------------
  Future<void> logout() async {
    _currentUser = null;
    await _prefs.remove(_sessionKey);
  }
}
