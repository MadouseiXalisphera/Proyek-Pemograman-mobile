class MenuItem {
  final String id;
  final String nama;
  final String deskripsi;
  final int harga;
  final String kategori;
  final String? fotoPath;
  final bool isTopPick;
  final int stock;

  const MenuItem({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.kategori,
    this.fotoPath,
    this.isTopPick = false,
    required this.stock,
  });

  factory MenuItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return MenuItem(
      id: json['id'].toString(),
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      harga: json['harga'],
      kategori: json['kategori'],
      fotoPath: json['fotoPath'],
      isTopPick: json['isTopPick'] ?? false,
      stock: json['stock'] ?? 0,
    );
  }
}
