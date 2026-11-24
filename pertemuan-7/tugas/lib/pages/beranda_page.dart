import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';
import '../widgets/kegiatan_tile.dart';
import '../widgets/ringkasan_card.dart';

class _DataHariIni {
  final Ringkasan ringkasan;
  final List<Kegiatan> daftar;
  const _DataHariIni({required this.ringkasan, required this.daftar});
}

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});
  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  late Future<_DataHariIni> _future;
  final _cariController = TextEditingController();
  Tipe? _filterTipe;

  String get _hariIni => formatTanggalIso(DateTime.now());

  @override
  void initState() {
    super.initState();
    _future = _ambil();
    versiData.addListener(_muat);
  }

  @override
  void dispose() {
    versiData.removeListener(_muat);
    _cariController.dispose();
    super.dispose();
  }

  void _muat() => setState(() => _future = _ambil());

  Future<_DataHariIni> _ambil() async {
    final tgl = _hariIni;
    final ringkasan = await DbHelper.ringkasan(tgl);
    final daftar = await DbHelper.pada(tgl, keyword: _cariController.text, filterTipe: _filterTipe);
    return _DataHariIni(ringkasan: ringkasan, daftar: daftar);
  }

  Future<void> _konfirmasiHapus(Kegiatan item) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Kegiatan?'),
        content: Text('Yakin ingin menghapus "${item.judul}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (yakin == true && item.id != null) await DbHelper.hapus(item.id!);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      body: FutureBuilder<_DataHariIni>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
            children: [
              Text('Hari Ini • ${formatTanggalIndo(_hariIni)}', style: tema.textTheme.titleSmall),
              const SizedBox(height: 8),
              ValueListenableBuilder<int>(
                valueListenable: PengaturanState.targetHarian,
                builder: (context, target, _) => RingkasanCard(ringkasan: data.ringkasan, targetHarian: target),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _cariController,
                decoration: InputDecoration(
                  hintText: 'Cari kegiatan hari ini...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _cariController.text.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _cariController.clear(); _muat(); })
                      : null,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (_) => _muat(),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Semua'),
                      selected: _filterTipe == null,
                      onSelected: (_) { _filterTipe = null; _muat(); },
                    ),
                    const SizedBox(width: 8),
                    for (final tipe in Tipe.values) ...[
                      FilterChip(
                        label: Text(tipe == Tipe.tanpa ? 'Tanpa Uang' : tipe.label),
                        selected: _filterTipe == tipe,
                        onSelected: (_) { _filterTipe = _filterTipe == tipe ? null : tipe; _muat(); },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text('Daftar Kegiatan', style: tema.textTheme.titleMedium),
              const SizedBox(height: 8),
              if (data.daftar.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('Belum ada kegiatan untuk ditampilkan.')),
                )
              else
                for (final item in data.daftar)
                  KegiatanTile(
                    kegiatan: item,
                    onToggleSelesai: (val) async => DbHelper.ubah(item.copyWith(selesai: val ?? false)),
                    onEdit: () => Navigator.pushNamed(context, '/form', arguments: item),
                    onDelete: () => _konfirmasiHapus(item),
                  ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/form'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
