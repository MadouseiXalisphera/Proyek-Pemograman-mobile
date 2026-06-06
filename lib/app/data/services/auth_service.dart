import 'dart:async';
import 'dart:convert';

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
  Future<String?> login(String username, String password) async {
    // Simulasi delay network 600ms
    await Future.delayed(const Duration(milliseconds: 600));

    // Cari user yang cocok pakai loop manual (sederhana & jelas)
    Map<String, dynamic>? matched;
    for (int i = 0; i < DummyData.users.length; i++) {
      final u = DummyData.users[i];
      if (u['username'] == username && u['password'] == password) {
        matched = u;
        break;
      }
    }

    if (matched == null) {
      return 'Username atau password salah';
    }

    // Semua role (user / kitchen / admin) boleh login. Routing setelah login
    // dicabang berdasarkan role lewat AppRoutes.shellForRole().
    // Buat objek user dan simpan ke memory + storage
    _currentUser = UserModel(
      username: matched['username'] as String,
      role: matched['role'] as String,
      namaMeja: matched['namaMeja'] as String?,
    );

    await _prefs.setString(
      _sessionKey,
      jsonEncode(_currentUser!.toJson()),
    );
    return null;
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
  bool verifyPassword(String password) {
    final user = _currentUser;
    if (user == null) return false;
    for (int i = 0; i < DummyData.users.length; i++) {
      final u = DummyData.users[i];
      if (u['username'] == user.username) {
        return u['password'] == password;
      }
    }
    return false;
  }

  // ---------------------------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------------------------
  Future<void> logout() async {
    _currentUser = null;
    await _prefs.remove(_sessionKey);
  }
}
