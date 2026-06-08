import 'dart:typed_data';

import 'package:get/get.dart';

/// Hasil unggah bukti bayar.
class ProofRef {
  /// Lokasi referensi bukti: URL (server/Supabase) atau path lokal.
  final String location;

  /// Byte (opsional) untuk preview cepat lintas platform (web).
  final Uint8List? bytes;

  const ProofRef({required this.location, this.bytes});
}

/// "Tempat" bukti pembayaran — SATU pintu (seam) untuk diganti backend.
///
/// Sekarang: [InMemoryProofStorage] (byte ditahan di RAM). Saat backend siap,
/// daftarkan implementasi lain TANPA mengubah controller/view:
///   - LocalFileProofStorage  : simpan ke folder app (path_provider).
///   - HttpProofStorage       : POST multipart ke REST API lokal (Laragon).
///   - SupabaseProofStorage   : upload ke Storage bucket, kembalikan public URL.
///
/// Cara pakai (di main.dart):
///   Get.put<ProofStorage>(InMemoryProofStorage(), permanent: true);
/// Lalu di CheckoutController:
///   final ref = await Get.find<ProofStorage>()
///       .upload(orderId: id, bytes: proofBytes!, filename: proofName);
///   // simpan ref.location ke OrderModel.paymentProofPath
abstract class ProofStorage {
  /// Unggah byte bukti utk [orderId]. Kembalikan [ProofRef] (location = URL/path).
  Future<ProofRef> upload({
    required String orderId,
    required Uint8List bytes,
    required String filename,
  });

  /// Ambil byte bukti (untuk preview), bila tersedia.
  Future<Uint8List?> fetch(String location);

  /// Hapus bukti (mis. saat order dibatalkan & dibersihkan).
  Future<void> remove(String location);
}

/// Implementasi LOKAL (RAM) — perilaku sama seperti sekarang, tapi sudah
/// melalui antarmuka yang benar sehingga gampang ditukar nanti.
class InMemoryProofStorage implements ProofStorage {
  final Map<String, Uint8List> _store = {};

  @override
  Future<ProofRef> upload({
    required String orderId,
    required Uint8List bytes,
    required String filename,
  }) async {
    final loc = 'mem://proofs/$orderId';
    _store[loc] = bytes;
    return ProofRef(location: loc, bytes: bytes);
  }

  @override
  Future<Uint8List?> fetch(String location) async => _store[location];

  @override
  Future<void> remove(String location) async {
    _store.remove(location);
  }
}
