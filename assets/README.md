# Folder Assets

Letakkan gambar asli di sini. Selama file belum ada, `AppMenuImage`
otomatis menampilkan placeholder abu-abu (tidak akan error merah).

## assets/menu/  — foto menu (disarankan rasio 4:3, JPG/PNG, < 300 KB)

Nama file HARUS sama dengan `id` menu di `lib/app/data/dummy_data.dart`:

- kopi_hitam.jpg
- matcha_latte.jpg
- lemon_tea.jpg
- es_teh_manis.jpg
- nasi_goreng.jpg
- roti_bakar.jpg
- pisang_goreng.jpg
- mie_goreng.jpg

## assets/payment/  — pembayaran

- qris.png   → gambar QRIS statis (dipakai di Fase D: expand pembayaran)

## Migrasi Supabase nanti

Saat pindah ke Supabase Storage, ganti `fotoPath` di dummy_data.dart
(atau kolom `foto_url` di tabel `menu`) dengan URL `https://...`.
`AppMenuImage` mengenali `http`/`https` dan otomatis pakai Image.network —
tidak ada widget yang perlu diubah.
