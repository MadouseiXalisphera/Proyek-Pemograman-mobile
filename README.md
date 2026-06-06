# ☕ Cafe Amba

Aplikasi pemesanan cafe berbasis Flutter dengan 3 jenis user dalam **satu app**:

| Role                    | Tugas                                        | Status                       |
| ----------------------- | -------------------------------------------- | ---------------------------- |
| **Pelanggan** (`user`)  | Pesan menu dari tablet di meja masing-masing | ✅ Lengkap (Fase A–E)        |
| **Kitchen** (`kitchen`) | Terima & olah pesanan, kelola stok menu      | ✅ Lengkap (Fase E–G)        |
| **Kasir** (`admin`)     | Validasi pembayaran, rekap pesanan           | 🚧 Inti jalan; halaman lengkap = pengembangan lanjutan |

### Alur pesanan (end-to-end)

Pelanggan checkout → pembayaran (expand inline: transfer/QRIS/cash + upload bukti)
→ masuk antrian **Kasir** untuk validasi manual → setelah dikonfirmasi, pesanan
muncul di **Kitchen** → kitchen jalankan 3 kondisi (Confirm Order → ✓ siap ambil
→ Selesai) → status + notifikasi mengalir balik ke tab Order **Pelanggan**.

---

## 🚀 Cara setup

```bash
flutter create cafe_amba
cd cafe_amba
```

1. Salin folder `lib/` dari starter ini ke project (timpa `lib/` lama)
2. Tambahkan dependencies dari `pubspec_dependencies.yaml` ke `pubspec.yaml`
3. `flutter pub get`
4. `flutter run`

---

## 🔑 Akun dummy untuk testing

| Username     | Password | Role    | Nama Meja |
| ------------ | -------- | ------- | --------- |
| `tablet_A1`  | `12345`  | user    | Meja A1   |
| `tablet_B2`  | `12345`  | user    | Meja B2   |
| `tablet_VIP` | `12345`  | user    | VIP Room  |
| `kasir01`    | `kasir`  | admin   | —         |
| `dapur01`    | `dapur`  | kitchen | —         |

> Ketiga role kini bisa login dalam **satu app** dan diarahkan ke shell
> masing-masing (lihat `AppRoutes.shellForRole`):
> `user` → UserShell (Home/Cart/Order/How to Use/Settings),
> `kitchen` → KitchenShell (Order/Menu Stock/Settings),
> `admin` → AdminShell (struktur untuk pengembangan lanjutan).

---

## 📦 Dependencies

`get`, `shared_preferences`, `google_fonts`, dan (Fase D) `image_picker` +
`gal`. Detail + izin platform (Android/iOS untuk galeri) ada di
`pubspec_dependencies.yaml`.

## 🔥 Migrasi ke Supabase nanti

Semua akses data sudah diisolasi di `lib/app/data/services/`.
Saat siap, cukup ganti isi method di service (`AuthService`, `OrderService`,
`MenuService`, `MenuStockService`, `PaymentSettingsService`) dengan panggilan
Supabase Auth + Postgres + Storage + Realtime. Controller, view, routes, dan
middleware **tidak perlu diubah**. Lihat `ARCHITECTURE.md` bagian "Peta migrasi
Supabase" dan `PRD.md`.
