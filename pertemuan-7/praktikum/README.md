# Praktikum Pertemuan 7 — Ringkasan Pembelajaran Mini Proyek Terpadu

Pada Pertemuan 7, materi pembelajaran difokuskan pada integrasi seluruh konsep Pemrograman Mobile (Pertemuan 1–6) ke dalam satu aplikasi terpadu **TabungKu** (kode lengkap berada di folder `tugas/`).

## Hal yang Dipelajari & Dipraktikkan

1. **Perancangan Arsitektur Folder Modular:** Memisahkan kode berdasarkan tanggung jawabnya ke dalam `models/`, `data/`, `state/`, `utils/`, `widgets/`, dan `pages/`.
2. **Persistensi Database Lokal (`sqflite`):** Merancang tabel SQLite `kegiatan`, menerapkan CRUD serta pencarian/filter (`LIKE` dan `WHERE`), dan query agregasi SQL (`COUNT`, `SUM`, `CASE WHEN`, `COALESCE`, `GROUP BY`).
3. **Sinkronisasi State Lintas Halaman:** Menggunakan `ValueNotifier<int> versiData` yang dipantau halaman **Hari Ini** dan **Laporan** melalui `addListener` dan `removeListener`.
4. **Penyimpanan Preferensi Pengguna (`shared_preferences`):** Menyimpan target tabungan harian, mode gelap/terang, dan pilihan warna tema Material 3.
5. **Navigasi Multi-Tab, Named Route, & Animasi:** `NavigationBar` + `IndexedStack` untuk 3 tab utama, `onGenerateRoute` (`/form`) dengan argumen objek `Kegiatan`, serta `TweenAnimationBuilder` untuk indikator progres tabungan.
