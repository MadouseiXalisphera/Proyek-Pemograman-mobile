import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Sumber gambar yang dikenali [AppMenuImage].
enum _ImageSourceKind { none, bytes, network, file, asset }

/// Widget gambar terpadu untuk seluruh app (kartu menu, detail, keranjang,
/// order kitchen, bukti bayar).
///
/// Satu pintu masuk supaya pergantian placeholder → gambar asli, dan migrasi
/// path lokal → URL Supabase Storage, cukup diubah di sini.
///
/// Resolusi sumber berdasarkan isi [path]:
/// - `null` / kosong              → placeholder solid
/// - diawali `http://`/`https://` → [Image.network]  (siap Supabase Storage)
/// - diawali `/` atau `file:`      → [Image.file]     (hasil upload lokal)
/// - selain itu                    → [Image.asset]    (aset bundel)
///
/// Semua jalur punya fallback ke placeholder bila gambar gagal dimuat,
/// jadi UI tidak pernah menampilkan error merah Flutter.
class AppMenuImage extends StatelessWidget {
  final String? path;

  /// Byte gambar (mis. hasil image_picker di web). Bila diisi, diutamakan
  /// daripada [path] dan dirender via [Image.memory] — bekerja lintas platform
  /// (web/desktop/mobile) tanpa perlu file path nyata.
  final Uint8List? bytes;

  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppMenuImage({
    super.key,
    this.path,
    this.bytes,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  _ImageSourceKind get _kind {
    if (bytes != null && bytes!.isNotEmpty) return _ImageSourceKind.bytes;
    final p = path;
    if (p == null || p.trim().isEmpty) return _ImageSourceKind.none;
    if (p.startsWith('http://') || p.startsWith('https://')) {
      return _ImageSourceKind.network;
    }
    if (p.startsWith('/') || p.startsWith('file:')) {
      return _ImageSourceKind.file;
    }
    return _ImageSourceKind.asset;
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.imagePlaceholder,
      alignment: Alignment.center,
      child: Icon(
        Icons.restaurant_menu,
        color: Colors.white.withValues(alpha: 0.35),
        size: 28,
      ),
    );
  }

  Widget _onError(BuildContext _, Object __, StackTrace? ___) => _placeholder();

  @override
  Widget build(BuildContext context) {
    Widget image;
    switch (_kind) {
      case _ImageSourceKind.none:
        image = _placeholder();
        break;
      case _ImageSourceKind.bytes:
        image = Image.memory(
          bytes!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: _onError,
        );
        break;
      case _ImageSourceKind.network:
        image = Image.network(
          path!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: _onError,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return _placeholder();
          },
        );
        break;
      case _ImageSourceKind.file:
        final clean = path!.startsWith('file:')
            ? Uri.parse(path!).toFilePath()
            : path!;
        image = Image.file(
          File(clean),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: _onError,
        );
        break;
      case _ImageSourceKind.asset:
        image = Image.asset(
          path!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: _onError,
        );
        break;
    }

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}
