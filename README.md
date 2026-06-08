# ☕ Cafe Amba

Aplikasi pemesanan cafe (Flutter + GetX), 3 peran dalam **satu app**.

| Role | Tugas | Status |
|---|---|---|
| **Pelanggan** (`user`) | Pesan dari tablet di meja | ✅ |
| **Kitchen** (`kitchen`) | Olah pesanan, stok, **riwayat** | ✅ |
| **Kasir** (`admin`) | Validasi pembayaran, rekap | 🚧 inti jalan; admin lengkap = lanjutan |

### Alur end-to-end
Checkout → pembayaran inline (transfer/QRIS/cash + upload bukti, validasi
format & ukuran) → antrian **Kasir** → **Konfirmasi (stok berkurang)** atau Tolak
→ muncul di **Kitchen** → 3 kondisi (Confirm Order → Done → Selesai) →
**notifikasi popup** (per item + nomor pesanan) mengalir balik ke **Pelanggan**.
Tiap pesanan punya **nomor per meja** (mis. `A1-3`) yang tampil di semua halaman
terkait (user, kitchen, kasir Payments/Orders, Riwayat dapur).

## 🚀 Setup
```bash
flutter create cafe_amba && cd cafe_amba
```
1. Salin `lib/` paket ini (timpa).
2. Salin `web/index.html`, `web/splash.css`, `web/splash.js` ke `web/`.
3. Tambah dependencies (`pubspec_dependencies.yaml`).
4. `flutter pub get` → `flutter run`.

Detail penempatan & verifikasi: `docs/CHANGELOG.md`.

## 🔑 Akun dummy
| Username | Password | Role | Meja |
|---|---|---|---|
| `tablet_A1` | `12345` | user | Meja A1 |
| `tablet_B2` | `12345` | user | Meja B2 |
| `tablet_VIP` | `12345` | user | VIP Room |
| `kasir01` | `kasir` | admin | — |
| `dapur01` | `dapur` | kitchen | — |

## 📦 Dependencies
`get`, `shared_preferences`, `google_fonts`, `image_picker`, `gal`.
(Supabase: `supabase_flutter` ditambah saat tahap Supabase.)

## 🔥 Supabase & integrasi admin (menyusul)
Panduan terperinci **lokal ↔ Supabase** (pembuatan database, backend/service,
integrasi admin, dan checklist file yang perlu diubah) ada di **`docs/BACKEND.md`**;
SQL kerangka di `supabase_later/setup.sql`.
