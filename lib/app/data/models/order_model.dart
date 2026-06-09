import 'dart:typed_data';

import 'cart_item_model.dart';

enum PaymentMethod { cash, transfer, qris }

/// Pesanan + siklus hidupnya.
///
/// ALUR (manual, tanpa payment gateway):
///   1. waiting_payment      → cash, menunggu bayar di kasir
///   2. waiting_confirmation → transfer/QRIS, bukti diunggah, menunggu kasir
///   3. confirmed            → kasir/admin validasi pembayaran (paymentConfirmed
///                             = true) → BARU muncul di kitchen
///   4. cooking / ready / done → diturunkan dari status item (kitchen)
///   x. cancelled            → kasir menolak
///
/// `statusKey` dihitung dari (cancelled, paymentConfirmed, paymentMethod,
/// status item) — satu sumber kebenaran, dipakai user, kitchen, dan admin.
class OrderModel {
  final String id;
  final String namaPemesan;
  final String namaMeja;
  final String? nomorHp;
  final String email;
  final PaymentMethod paymentMethod;
  final List<CartItem> items;
  final int totalHarga;
  final DateTime createdAt;

  /// Path bukti pembayaran (lokal sekarang; URL Supabase Storage nanti).
  final String? paymentProofPath;

  /// Byte gambar bukti (preview lintas platform, termasuk web).
  final Uint8List? paymentProofBytes;

  /// Divalidasi kasir/admin. Pesanan baru tampil di kitchen bila true.
  bool paymentConfirmed;

  /// Dibatalkan kasir/admin.
  bool cancelled;

  /// Nomor urut pesanan PER MEJA (di-set OrderService saat addOrder/seed).
  /// 0 = belum ditetapkan. Lihat [displayNo] untuk format tampilan.
  int orderNo;

  OrderModel({
    required this.id,
    required this.namaPemesan,
    required this.namaMeja,
    this.nomorHp,
    required this.email,
    required this.paymentMethod,
    required this.items,
    required this.totalHarga,
    required this.createdAt,
    this.paymentProofPath,
    this.paymentProofBytes,
    this.paymentConfirmed = false,
    this.cancelled = false,
    this.orderNo = 0,
  });

  /// Kode meja ringkas untuk nomor pesanan: "Meja A1" → "A1", "VIP Room" → "VIP".
  String get _mejaCode {
    var m = namaMeja.trim();
    if (m.toLowerCase().startsWith('meja ')) m = m.substring(5).trim();
    final sp = m.indexOf(' ');
    if (sp > 0) m = m.substring(0, sp);
    return m.toUpperCase();
  }

  /// Nomor pesanan yang ditampilkan (PER MEJA), mis. "A1-3".
  /// Dipakai seragam di user, kitchen, dan kasir agar tidak tumpang tindih.
  String get displayNo => orderNo > 0 ? '$_mejaCode-$orderNo' : _mejaCode;

  /// Kunci status lifecycle untuk ditampilkan (lihat OrderStatusView).
  String get statusKey {
    if (cancelled) return 'cancelled';
    if (!paymentConfirmed) {
      return paymentMethod == PaymentMethod.cash
          ? 'waiting_payment'
          : 'waiting_confirmation';
    }
    // Sudah dibayar → fase kitchen, diturunkan dari status item.
    if (items.isEmpty) return 'confirmed';
    final allDone = items.every((i) => i.status == ItemStatus.done);
    if (allDone) return 'done';
    final noneConfirm = items.every((i) => i.status != ItemStatus.confirm);
    if (noneConfirm) return 'ready';
    final anyAdvanced = items.any((i) => i.status != ItemStatus.confirm);
    if (anyAdvanced) return 'cooking';
    return 'confirmed';
  }

  /// Tampil di kitchen: sudah dibayar, belum dibatalkan, belum semua selesai.
  bool get isVisibleToKitchen =>
      paymentConfirmed &&
      !cancelled &&
      !(items.isNotEmpty && items.every((i) => i.status == ItemStatus.done));

  /// Menunggu validasi kasir (untuk daftar di admin).
  bool get awaitingPayment => !paymentConfirmed && !cancelled;
}

String paymentMethodLabel(PaymentMethod m) {
  switch (m) {
    case PaymentMethod.cash:
      return 'Cash';
    case PaymentMethod.transfer:
      return 'Transfer';
    case PaymentMethod.qris:
      return 'QRIS';
  }
}
