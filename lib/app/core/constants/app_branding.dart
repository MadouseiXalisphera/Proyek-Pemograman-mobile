/// Identitas brand aplikasi — UBAH DI SINI.
///
/// - [appName]   : nama sistem yang tampil di splash & tempat lain.
/// - [tagline]   : teks kecil di bawah nama (boleh dikosongkan).
/// - [logoAssetPath] : kosong ('') = pakai ikon default (cangkir kopi).
///   Untuk mengganti dengan GAMBAR nanti:
///     1. Taruh file mis. `assets/branding/logo.png`
///     2. Daftarkan folder `assets/branding/` di pubspec.yaml (bagian assets)
///     3. Isi path-nya di sini, contoh: 'assets/branding/logo.png'
///   [AppLogo] otomatis merender gambar bila path diisi.
class AppBranding {
  AppBranding._();

  static const String appName = 'Cafe Amba';
  static const String tagline = 'Self-Order System';
  static const String logoAssetPath = '';
}
