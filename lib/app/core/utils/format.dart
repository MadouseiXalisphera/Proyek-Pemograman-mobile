/// Format integer rupiah dengan "Rp" prefix dan titik ribuan.
/// 49000 → "Rp 49.000"
/// 171000 → "Rp 171.000"
String formatRupiah(int value) {
  final str = value.toString();
  final buffer = StringBuffer('Rp ');
  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(str[i]);
  }
  return buffer.toString();
}
