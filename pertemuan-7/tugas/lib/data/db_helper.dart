import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';

final versiData = ValueNotifier<int>(0);

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tabungku.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE kegiatan(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            tanggal TEXT NOT NULL,
            selesai INTEGER NOT NULL DEFAULT 0,
            tipe TEXT NOT NULL,
            nominal INTEGER NOT NULL DEFAULT 0,
            kategori TEXT NOT NULL DEFAULT '-'
          )
        ''');
      },
    );
    return _db!;
  }

  static void _tandaiBerubah() => versiData.value++;

  static Future<int> tambah(Kegiatan k) async {
    final db = await database;
    final id = await db.insert('kegiatan', k.toMap()..remove('id'));
    _tandaiBerubah();
    return id;
  }

  static Future<int> ubah(Kegiatan k) async {
    final db = await database;
    final count = await db.update('kegiatan', k.toMap(), where: 'id = ?', whereArgs: [k.id]);
    _tandaiBerubah();
    return count;
  }

  static Future<int> hapus(int id) async {
    final db = await database;
    final count = await db.delete('kegiatan', where: 'id = ?', whereArgs: [id]);
    _tandaiBerubah();
    return count;
  }

  static Future<List<Kegiatan>> pada(String tanggal, {String keyword = '', Tipe? filterTipe}) async {
    final db = await database;
    final whereClauses = <String>['tanggal = ?'];
    final whereArgs = <Object?>[tanggal];
    if (keyword.trim().isNotEmpty) {
      whereClauses.add('judul LIKE ?');
      whereArgs.add('%${keyword.trim()}%');
    }
    if (filterTipe != null) {
      whereClauses.add('tipe = ?');
      whereArgs.add(filterTipe.name);
    }
    final rows = await db.query(
      'kegiatan',
      where: whereClauses.join(' AND '),
      whereArgs: whereArgs,
      orderBy: 'selesai ASC, id DESC',
    );
    return rows.map((e) => Kegiatan.fromMap(e)).toList();
  }

  static Future<Ringkasan> ringkasan(String tanggal) async {
    final db = await database;
    final hasil = await db.rawQuery('''
      SELECT
        COUNT(*) AS jumlah,
        COALESCE(SUM(selesai), 0) AS selesai,
        COALESCE(SUM(CASE WHEN tipe = 'pemasukan' THEN nominal END), 0) AS masuk,
        COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' THEN nominal END), 0) AS keluar,
        COALESCE(SUM(CASE WHEN tipe = 'pemasukan' AND selesai = 1 THEN nominal END), 0) AS masuk_selesai,
        COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' AND selesai = 1 THEN nominal END), 0) AS keluar_selesai
      FROM kegiatan WHERE tanggal = ?
    ''', [tanggal]);
    final b = hasil.first;
    return Ringkasan(
      jumlahKegiatan: (b['jumlah'] as num).toInt(),
      selesai: (b['selesai'] as num).toInt(),
      pemasukan: (b['masuk'] as num).toInt(),
      pengeluaran: (b['keluar'] as num).toInt(),
      pemasukanSelesai: (b['masuk_selesai'] as num).toInt(),
      pengeluaranSelesai: (b['keluar_selesai'] as num).toInt(),
    );
  }

  static Future> pengeluaranPerKategori(String tanggal) async {
    final db = await database;
    final hasil = await db.rawQuery('''
      SELECT kategori, COALESCE(SUM(nominal), 0) AS total
      FROM kegiatan WHERE tanggal = ? AND tipe = 'pengeluaran'
      GROUP BY kategori ORDER BY total DESC
    ''', [tanggal]);
    return {for (final r in hasil) r['kategori'] as String: (r['total'] as num).toInt()};
  }

  static Future<List<RingkasanHarian>> tujuhHariTerakhir(DateTime acuan) async {
    final db = await database;
    final daftar = <RingkasanHarian>[];
    for (int i = 0; i < 7; i++) {
      final tgl = formatTanggalIso(acuan.subtract(Duration(days: i)));
      final hasil = await db.rawQuery('''
        SELECT
          COALESCE(SUM(CASE WHEN tipe = 'pemasukan' THEN nominal END), 0) AS masuk,
          COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' THEN nominal END), 0) AS keluar
        FROM kegiatan WHERE tanggal = ?
      ''', [tgl]);
      final b = hasil.first;
      daftar.add(RingkasanHarian(
        tanggal: tgl,
        pemasukan: (b['masuk'] as num).toInt(),
        pengeluaran: (b['keluar'] as num).toInt(),
      ));
    }
    return daftar;
  }
}
