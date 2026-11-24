String formatRupiah(int angka) {
  final negatif = angka < 0;
  final s = angka.abs().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final sisa = s.length - i;
    if (i > 0 && sisa % 3 == 0) buffer.write('.');
    buffer.write(s[i]);
  }
  return '${negatif ? '-Rp ' : 'Rp '}${buffer.toString()}';
}

String formatTanggalIso(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String formatTanggalIndo(String iso) {
  const bulan = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  final parts = iso.split('-');
  if (parts.length != 3) return iso;
  final d = int.tryParse(parts[2]) ?? 1;
  final m = int.tryParse(parts[1]) ?? 1;
  return '$d ${bulan[m]} ${parts[0]}';
}
