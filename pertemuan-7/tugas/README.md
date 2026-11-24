# Tugas Mini Proyek Terpadu — TabungKu

## Daftar Fitur

- F1: Daftar kegiatan hari ini dengan centang selesai, ubah, dan hapus dengan dialog konfirmasi.
- F2: Form tambah/ubah kegiatan dengan pemilih tanggal, jenis keuangan, nominal, kategori, dan validasi.
- F3: Penyimpanan persisten SQLite pada tabel kegiatan.
- F4: Ringkasan harian (kegiatan selesai/total, pemasukan, pengeluaran, tabungan).
- F5: Halaman Laporan (pilih tanggal, pengeluaran per kategori, riwayat 7 hari terakhir).
- F6: Target tabungan harian dengan indikator progres beranimasi.
- F7: Pengaturan target harian, mode gelap, dan warna tema (shared_preferences).
- F8: Navigasi 3 tab (NavigationBar + IndexedStack) dan form via named route (/form).

## Fitur Pengembangan Lanjutan

1. Pencarian dan Filter Kegiatan (LIKE & WHERE pada halaman Hari Ini).
2. Rencana vs Realisasi (perbandingan tabungan semua kegiatan vs kegiatan selesai).
3. Ekspor Laporan ke Clipboard.

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
