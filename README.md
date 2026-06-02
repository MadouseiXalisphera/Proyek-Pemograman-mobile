# ☕ Cafe Amba

Aplikasi pemesanan cafe berbasis Flutter dengan 3 jenis user:

| Role                    | Tugas                                        | Status                    |
| ----------------------- | -------------------------------------------- | ------------------------- |
| **Pelanggan** (`user`)  | Pesan menu dari tablet di meja masing-masing | 🚧 In progress (Login ✅) |
| **Kitchen** (`kitchen`) | Terima & olah pesanan masuk                  | ⏳ Belum                  |
| **Kasir** (`admin`)     | Kelola pembayaran, pesanan, dll              | ⏳ Belum                  |

Saat ini fokus pengembangan ada di **sisi Pelanggan**.

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

> Saat ini hanya role `user` yang bisa login. Akun admin/kitchen ditolak (akan dipakai di app terpisah).

---

## 🔥 Migrasi ke Firebase nanti

Semua akses data sudah diisolasi di `lib/app/data/services/`.
Saat siap, cukup ganti isi method di `AuthService` (dan service lain) dengan panggilan Firebase Auth + Firestore. Controller, view, routes, dan middleware **tidak perlu diubah**.
