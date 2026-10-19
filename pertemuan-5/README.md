# Pertemuan 5 — Penyimpanan Lokal Flutter

Materi: SharedPreferences dan SQLite.

## Struktur
- `praktikum/bagian_a`: pengaturan sederhana dengan SharedPreferences.
- `praktikum/bagian_b`: model Catatan dan helper database SQLite.
- `praktikum/bagian_c`: daftar catatan (Read dan Delete).
- `praktikum/bagian_d`: form tambah dan ubah catatan.
- `tugas`: aplikasi Pencatat Pengeluaran dengan CRUD, validasi, total pengeluaran, dan pengaturan yang disimpan.

## Menjalankan
Setiap folder berisi contoh kode/README sesuai bagian modul. Untuk aplikasi tugas:
1. Buat proyek Flutter baru atau salin `tugas/main.dart` ke `lib/main.dart` proyek Flutter.
2. Jalankan:
   ```bash
   flutter pub add sqflite path shared_preferences
   flutter run
   ```
3. Jalankan di emulator Android/iOS. `sqflite` tidak berjalan langsung di web.

Lihat README pada setiap bagian untuk petunjuk dan checkpoint.
