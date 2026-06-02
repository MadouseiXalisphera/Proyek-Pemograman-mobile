class MenuItem {
  final String id;
  final String nama;
  final String deskripsi;
  final int harga;
  final String kategori; // 'food' | 'drink'
  final String? fotoPath;
  final bool isTopPick;

  const MenuItem({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.kategori,
    this.fotoPath,
    this.isTopPick = false,
  });
}
