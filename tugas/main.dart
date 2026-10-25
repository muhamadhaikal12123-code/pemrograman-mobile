import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(const PengeluaranApp());

class Pengeluaran {
  final int? id;
  final String nama;
  final int jumlah;
  final String kategori;
  final String tanggal;
  const Pengeluaran({this.id, required this.nama, required this.jumlah, required this.kategori, required this.tanggal});
  Map<String, Object?> toMap() => {'id': id, 'nama': nama, 'jumlah': jumlah, 'kategori': kategori, 'tanggal': tanggal};
  factory Pengeluaran.fromMap(Map<String, Object?> m) => Pengeluaran(
    id: m['id'] as int,
    nama: m['nama'] as String,
    jumlah: m['jumlah'] as int,
    kategori: m['kategori'] as String,
    tanggal: m['tanggal'] as String,
  );
}

class DatabaseHelper {
  static Database? _db;
  static Future<Database> get database async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), 'pengeluaran.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE pengeluaran(id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT NOT NULL, jumlah INTEGER NOT NULL, kategori TEXT NOT NULL, tanggal TEXT NOT NULL)');
    });
    return _db!;
  }
  static Future<List<Pengeluaran>> semua() async {
    final rows = await (await database).query('pengeluaran', orderBy: 'id DESC');
    return rows.map(Pengeluaran.fromMap).toList();
  }
  static Future<int> tambah(Pengeluaran x) async => (await database).insert('pengeluaran', x.toMap());
  static Future<int> ubah(Pengeluaran x) async => (await database).update('pengeluaran', x.toMap(), where: 'id = ?', whereArgs: [x.id]);
  static Future<int> hapus(int id) async => (await database).delete('pengeluaran', where: 'id = ?', whereArgs: [id]);
}

class PengeluaranApp extends StatefulWidget {
  const PengeluaranApp({super.key});
  @override
  State<PengeluaranApp> createState() => _PengeluaranAppState();
}
class _PengeluaranAppState extends State<PengeluaranApp> {
  bool _gelap = false;
  bool _siap = false;
  @override
  void initState() {
    super.initState();
    _muatPreferensi();
  }
  Future<void> _muatPreferensi() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() { _gelap = prefs.getBool('modeGelap') ?? false; _siap = true; });
  }
  Future<void> _ubahTema(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modeGelap', value);
    if (mounted) setState(() => _gelap = value);
  }
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Pencatat Pengeluaran',
    theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true, brightness: _gelap ? Brightness.dark : Brightness.light),
    home: _siap ? PengeluaranPage(gelap: _gelap, onTemaChanged: _ubahTema) : const Scaffold(body: Center(child: CircularProgressIndicator())),
  );
}

class PengeluaranPage extends StatefulWidget {
  final bool gelap;
  final ValueChanged<bool> onTemaChanged;
  const PengeluaranPage({super.key, required this.gelap, required this.onTemaChanged});
  @override
  State<PengeluaranPage> createState() => _PengeluaranPageState();
}
class _PengeluaranPageState extends State<PengeluaranPage> {
  late Future<List<Pengeluaran>> _future;
  @override
  void initState() {
    super.initState();
    _future = DatabaseHelper.semua();
  }
  void _muat() => setState(() => _future = DatabaseHelper.semua());
  String _rupiah(int value) => 'Rp ${value.toString().replaceAllMapped(RegExp(r'\\B(?=(\\d{3})+(?!\\d))'), (m) => '.')}';
  String _tanggalSekarang() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
  }
  Future<void> _bukaForm([Pengeluaran? item]) async {
    final result = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => FormPengeluaranPage(item: item)));
    if (result == true && mounted) _muat();
  }
  Future<void> _hapus(Pengeluaran item) async {
    final yakin = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('Hapus pengeluaran?'),
      content: Text('Hapus "${item.nama}" dari daftar?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
      ],
    ));
    if (yakin == true && item.id != null) {
      await DatabaseHelper.hapus(item.id!);
      if (mounted) _muat();
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pencatat Pengeluaran'), actions: [
      IconButton(tooltip: 'Pengaturan tema', onPressed: () => widget.onTemaChanged(!widget.gelap), icon: Icon(widget.gelap ? Icons.dark_mode : Icons.light_mode)),
    ]),
    body: FutureBuilder<List<Pengeluaran>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Center(child: Text('Terjadi galat: ${snapshot.error}'));
        final data = snapshot.data ?? [];
        final total = data.fold<int>(0, (sum, item) => sum + item.jumlah);
        return Column(children: [
          Card(margin: const EdgeInsets.fromLTRB(16, 16, 16, 8), child: ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: const Text('Total Pengeluaran'),
            subtitle: Text(_rupiah(total), style: Theme.of(context).textTheme.headlineSmall),
            trailing: Text('${data.length} transaksi'),
          )),
          Expanded(child: data.isEmpty
            ? const Center(child: Text('Belum ada pengeluaran. Tekan + untuk menambah.'))
            : ListView.builder(itemCount: data.length, itemBuilder: (context, i) {
              final x = data[i];
              return Card(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5), child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
                title: Text(x.nama),
                subtitle: Text('${x.kategori} • ${x.tanggal}'),
                trailing: Text(_rupiah(x.jumlah), style: const TextStyle(fontWeight: FontWeight.bold)),
                onTap: () => _bukaForm(x),
                onLongPress: () => _hapus(x),
              ));
            }),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 8), child: Text('Ketuk transaksi untuk mengubah • Tekan lama untuk menghapus', style: Theme.of(context).textTheme.bodySmall)),
        ]);
      },
    ),
    floatingActionButton: FloatingActionButton.extended(onPressed: () => _bukaForm(), icon: const Icon(Icons.add), label: const Text('Tambah')),
  );
}

class FormPengeluaranPage extends StatefulWidget {
  final Pengeluaran? item;
  const FormPengeluaranPage({super.key, this.item});
  @override
  State<FormPengeluaranPage> createState() => _FormPengeluaranPageState();
}
class _FormPengeluaranPageState extends State<FormPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nama;
  late final TextEditingController _jumlah;
  late String _kategori;
  static const List<String> _kategoriList = ['Makanan', 'Transportasi', 'Belanja', 'Tagihan', 'Pendidikan', 'Hiburan', 'Lainnya'];
  @override
  void initState() {
    super.initState();
    _nama = TextEditingController(text: widget.item?.nama ?? '');
    _jumlah = TextEditingController(text: widget.item?.jumlah.toString() ?? '');
    _kategori = widget.item?.kategori ?? _kategoriList.first;
  }
  @override
  void dispose() {
    _nama.dispose();
    _jumlah.dispose();
    super.dispose();
  }
  String _tanggalHariIni() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
  }
  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    final data = Pengeluaran(
      id: widget.item?.id,
      nama: _nama.text.trim(),
      jumlah: int.parse(_jumlah.text.trim()),
      kategori: _kategori,
      tanggal: widget.item?.tanggal ?? _tanggalHariIni(),
    );
    if (widget.item == null) {
      await DatabaseHelper.tambah(data);
    } else {
      await DatabaseHelper.ubah(data);
    }
    if (mounted) Navigator.pop(context, true);
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.item == null ? 'Tambah Pengeluaran' : 'Ubah Pengeluaran')),
    body: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(16), children: [
      TextFormField(controller: _nama, textCapitalization: TextCapitalization.sentences, decoration: const InputDecoration(labelText: 'Nama pengeluaran', border: OutlineInputBorder(), prefixIcon: Icon(Icons.edit_note)), validator: (v) => v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null),
      const SizedBox(height: 14),
      TextFormField(controller: _jumlah, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah (Rupiah)', border: OutlineInputBorder(), prefixText: 'Rp '), validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Jumlah wajib diisi';
        final n = int.tryParse(v.trim());
        if (n == null) return 'Jumlah harus berupa angka bulat';
        if (n <= 0) return 'Jumlah harus lebih dari 0';
        return null;
      }),
      const SizedBox(height: 14),
      DropdownButtonFormField<String>(value: _kategori, decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()), items: _kategoriList.map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(), onChanged: (v) { if (v != null) setState(() => _kategori = v); }, validator: (v) => v == null ? 'Pilih kategori' : null),
      const SizedBox(height: 22),
      FilledButton.icon(onPressed: _simpan, icon: const Icon(Icons.save), label: const Text('Simpan Pengeluaran')),
    ])),
  );
}
