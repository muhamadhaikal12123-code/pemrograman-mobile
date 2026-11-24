import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';
import '../widgets/ringkasan_card.dart';

class _DataLaporan {
  final Ringkasan ringkasan;
  final Map<String, int> perKategori;
  final List<RingkasanHarian> tujuhHari;
  const _DataLaporan({required this.ringkasan, required this.perKategori, required this.tujuhHari});
}

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});
  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  DateTime _tanggalDipilih = DateTime.now();
  late Future<_DataLaporan> _future;

  @override
  void initState() {
    super.initState();
    _future = _ambil();
    versiData.addListener(_muat);
  }

  @override
  void dispose() {
    versiData.removeListener(_muat);
    super.dispose();
  }

  void _muat() => setState(() => _future = _ambil());

  Future<_DataLaporan> _ambil() async {
    final iso = formatTanggalIso(_tanggalDipilih);
    return _DataLaporan(
      ringkasan: await DbHelper.ringkasan(iso),
      perKategori: await DbHelper.pengeluaranPerKategori(iso),
      tujuhHari: await DbHelper.tujuhHariTerakhir(_tanggalDipilih),
    );
  }

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggalDipilih,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (hasil != null) {
      _tanggalDipilih = hasil;
      _muat();
    }
  }

  Future<void> _salinLaporan(_DataLaporan data) async {
    final iso = formatTanggalIso(_tanggalDipilih);
    final r = data.ringkasan;
    final teks = 'Laporan TabungKu (${formatTanggalIndo(iso)})\n'
        'Kegiatan Selesai: ${r.selesai}/${r.jumlahKegiatan}\n'
        'Pemasukan: ${formatRupiah(r.pemasukan)}\n'
        'Pengeluaran: ${formatRupiah(r.pengeluaran)}\n'
        'Tabungan Rencana: ${formatRupiah(r.tabungan)}\n'
        'Tabungan Realisasi (Selesai): ${formatRupiah(r.tabunganRealisasi)}';
    await Clipboard.setData(ClipboardData(text: teks));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ringkasan laporan disalin ke clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colors = tema.colorScheme;
    final iso = formatTanggalIso(_tanggalDipilih);

    return FutureBuilder<_DataLaporan>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

        final data = snapshot.data!;
        final r = data.ringkasan;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pilihTanggal,
                    icon: const Icon(Icons.calendar_month),
                    label: Text('Tanggal: ${formatTanggalIndo(iso)}'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: () => _salinLaporan(data),
                  tooltip: 'Salin Laporan ke Clipboard',
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<int>(
              valueListenable: PengaturanState.targetHarian,
              builder: (context, target, _) => RingkasanCard(ringkasan: r, targetHarian: target),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rencana vs Realisasi (Kegiatan Selesai)', style: tema.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Rencana (Semua): ${formatRupiah(r.tabungan)}'),
                    Text('Realisasi (Selesai): ${formatRupiah(r.tabunganRealisasi)}'),
                    Text(
                      'Selisih: ${formatRupiah(r.selisihRealisasi)}',
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: r.selisihRealisasi < 0 ? colors.error : colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Pengeluaran per Kategori', style: tema.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (data.perKategori.isEmpty)
              const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Tidak ada pengeluaran pada tanggal ini.')))
            else
              Card(
                child: Column(
                  children: data.perKategori.entries
                      .map((e) => ListTile(
                            leading: const Icon(Icons.category_outlined),
                            title: Text(e.key),
                            trailing: Text(formatRupiah(e.value),
                                style: tema.textTheme.titleSmall?.copyWith(color: colors.error, fontWeight: FontWeight.bold)),
                          ))
                      .toList(),
                ),
              ),
            const SizedBox(height: 16),
            Text('Riwayat 7 Hari Terakhir', style: tema.textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: data.tujuhHari
                    .map((h) => ListTile(
                          title: Text(formatTanggalIndo(h.tanggal)),
                          subtitle: Text('Masuk: ${formatRupiah(h.pemasukan)} • Keluar: ${formatRupiah(h.pengeluaran)}'),
                          trailing: Text(formatRupiah(h.tabungan),
                              style: tema.textTheme.titleSmall?.copyWith(
                                color: h.tabungan < 0 ? colors.error : colors.primary,
                                fontWeight: FontWeight.bold,
                              )),
                        ))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
