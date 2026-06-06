import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/payment_info.dart';

/// Sumber gambar QRIS yang bisa diganti.
///
/// PRIORITAS resolusi (dipakai juga sebagai pola umum untuk gambar yang
/// boleh diganti runtime):
///   1. Override runtime  → di-set admin (lokal: path file hasil upload;
///                          Supabase nanti: URL `https://...storage.../`)
///   2. Aset bundel       → PaymentInfo.qrisAssetPath (assets/payment/qris.png)
///
/// AppMenuImage sudah mengenali file/URL/asset, jadi cukup memberi string yang
/// tepat dari sini. Override dipersist di SharedPreferences supaya bertahan
/// setelah app ditutup (lokal). Saat Supabase, ganti penyimpanan ke kolom DB.
class PaymentSettingsService {
  static const String _qrisKey = 'qris_override_path';

  final RxnString _qrisOverride = RxnString();

  SharedPreferences get _prefs => Get.find<SharedPreferences>();

  /// Dipanggil sekali saat startup (sesudah SharedPreferences siap).
  void load() {
    final saved = _prefs.getString(_qrisKey);
    if (saved != null && saved.trim().isNotEmpty) {
      _qrisOverride.value = saved;
    }
  }

  /// Path/URL QRIS efektif untuk ditampilkan (reaktif bila dibaca di Obx).
  String get qrisPath => _qrisOverride.value ?? PaymentInfo.qrisAssetPath;

  bool get usingDefaultQris => _qrisOverride.value == null;

  /// Dipakai admin (atau tester) untuk mengganti QRIS tanpa rebuild.
  /// [path] bisa berupa path file lokal hasil upload, atau URL Supabase.
  Future<void> setQrisOverride(String path) async {
    _qrisOverride.value = path;
    await _prefs.setString(_qrisKey, path);
  }

  /// Kembali ke QRIS bawaan (aset bundel).
  Future<void> clearQrisOverride() async {
    _qrisOverride.value = null;
    await _prefs.remove(_qrisKey);
  }
}
