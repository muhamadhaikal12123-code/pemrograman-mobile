# Pertemuan 7 - Mini Proyek Terpadu: TabungKu

TabungKu adalah aplikasi manajemen kegiatan harian (to-do list) yang terintegrasi dengan pencatatan keuangan harian untuk membantu mahasiswa memantau pemasukan, pengeluaran per kategori, dan progres target tabungan harian.

## Daftar Fitur

- F1: Daftar kegiatan hari ini dengan status centang selesai, ubah data, dan hapus dengan dialog konfirmasi.
- F2: Form tambah/ubah kegiatan dengan input nama, pemilih tanggal (DatePicker), jenis keuangan (Tidak melibatkan uang, Pemasukan, Pengeluaran), nominal, kategori, serta validasi input.
- F3: Penyimpanan persisten menggunakan SQLite (sqflite) pada tabel kegiatan.
- F4: Ringkasan harian (kegiatan selesai/total, pemasukan, pengeluaran, dan tabungan).
- F5: Halaman Laporan berisi pemilih tanggal, ringkasan harian, pengeluaran per kategori (GROUP BY), dan riwayat 7 hari terakhir.
- F6: Target tabungan harian dengan indikator progres beranimasi (TweenAnimationBuilder), peringatan saat tabungan negatif, dan apresiasi saat target tercapai.
- F7: Halaman Pengaturan untuk mengatur target harian, mode gelap/terang, dan pilihan warna tema (shared_preferences).
- F8: Navigasi 3 tab (NavigationBar + IndexedStack) serta halaman form via named route (/form).

## Fitur Pengembangan Lanjutan

1. Pencarian dan Filter Kegiatan: Filter berdasarkan kata kunci judul (LIKE) dan jenis keuangan (WHERE) di tab Hari Ini.
2. Rencana vs Realisasi: Perbandingan perhitungan tabungan seluruh kegiatan vs kegiatan yang sudah dicentang selesai beserta selisihnya di tab Laporan.
3. Ekspor Laporan ke Clipboard: Tombol salin ringkasan laporan harian ke papan klip (Clipboard).

## Cara Menjalankan

1. Jalankan: flutter pub get
2. Jalankan: flutter run

## Tabel Hasil Skenario Uji

| No | Langkah | Hasil yang Diharapkan | Status |
| :-- | :--- | :--- | :--- |
| 1 | Tambah kegiatan Belajar jenis Tidak | Muncul di daftar; jumlah kegiatan naik; pemasukan/pengeluaran tetap | Lulus |
| 2 | Tambah kegiatan jenis Pemasukan Rp 50.000 | Pemasukan Rp 50.000; tabungan naik Rp 50.000; nominal hijau dengan tanda + | Lulus |
| 3 | Tambah kegiatan jenis Pengeluaran Rp 15.000 kategori Makan | Pengeluaran naik; tabungan turun; kategori Makan muncul di Laporan | Lulus |
| 4 | Simpan kegiatan bernama kosong / nominal kosong / nominal 0 | Pesan kesalahan tampil dan data tidak tersimpan | Lulus |
| 5 | Centang selesai dua kegiatan | Kartu ringkasan menunjukkan selesai/total benar; judul tercoret | Lulus |
| 6 | Ubah nominal kegiatan yang sudah ada | Ringkasan dan laporan ikut berubah tanpa restart | Lulus |
| 7 | Hapus kegiatan (pilih Batal, lalu Hapus) | Batal tidak menghapus; Hapus menghapus dan ringkasan berkurang | Lulus |
| 8 | Tambah kegiatan bertanggal kemarin | Tidak muncul di Hari Ini; muncul di Laporan tanggal tersebut & daftar 7 hari | Lulus |
| 9 | Ubah target & warna, aktifkan mode gelap, tutup lalu buka lagi | Semua pengaturan dan data tetap | Lulus |
| 10 | Buat pengeluaran lebih besar dari pemasukan | Tabungan negatif berwarna merah dan muncul pesan peringatan | Lulus |
