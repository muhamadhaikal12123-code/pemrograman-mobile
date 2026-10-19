# Tugas — Aplikasi Pencatat Pengeluaran

Fitur:
- CRUD pengeluaran menggunakan SQLite.
- Validasi nama wajib, jumlah harus angka lebih dari 0, kategori dropdown.
- Total pengeluaran di halaman utama.
- Preferensi mode gelap disimpan dengan SharedPreferences.
- Data bertahan setelah aplikasi ditutup dan dibuka kembali.

## Menjalankan
Di proyek Flutter, jalankan:
```bash
flutter pub add sqflite path shared_preferences
```
Salin `main.dart` ke `lib/main.dart`, lalu jalankan `flutter run` pada emulator Android/iOS. Ambil screenshot daftar, form, dan bukti data masih ada setelah restart untuk pengumpulan.
