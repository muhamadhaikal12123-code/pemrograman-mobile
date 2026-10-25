# Pertemuan 3 — Form Input dan State Management

## Deskripsi

Pada pertemuan ketiga, saya mempelajari cara menerima input dari pengguna dan mengelola data di dalam aplikasi Flutter. Materi dimulai dari penggunaan `TextField` untuk memasukkan teks, kemudian dilanjutkan dengan form yang memiliki validasi dan pilihan input.

Praktikum ini juga membahas state management, yaitu cara mengatur perubahan data agar tampilan aplikasi tetap sesuai dengan kondisi terbaru.

## Materi yang Dipelajari

- Menggunakan `TextField` untuk menerima input pengguna.
- Mengelola teks menggunakan `TextEditingController`.
- Membuat form dan melakukan validasi input.
- Menggunakan dropdown dan checkbox.
- Memahami penggunaan `setState()` untuk memperbarui tampilan.
- Mengenal `ChangeNotifier` dan Provider untuk mengelola state.
- Menampilkan pesan menggunakan `SnackBar`.
- Menghapus data dari daftar dan menangani kondisi ketika daftar masih kosong.

## Praktikum

### Bagian A — TextField dan Controller
Membuat input teks dan mempelajari cara mengambil nilai yang dimasukkan pengguna menggunakan `TextEditingController`. Controller digunakan agar isi input dapat dibaca dan dikelola melalui kode.

### Bagian B — Form dan Validasi
Membuat form pendaftaran dengan beberapa jenis input, termasuk teks, dropdown, dan checkbox. Form diperiksa sebelum diproses agar input yang diperlukan tidak dibiarkan kosong.

### Bagian C — State Management
Mempelajari perbedaan pengelolaan state menggunakan `setState()` dan pendekatan state management. Tujuannya untuk memahami bagaimana perubahan data dapat memengaruhi tampilan aplikasi.

### Bagian D — ChangeNotifier dan Provider
Membuat aplikasi daftar tugas menggunakan `ChangeNotifier` dan Provider. Data tugas dapat ditambahkan dan dihapus, sedangkan tampilan diperbarui ketika data berubah. Praktikum ini juga mencakup validasi input, kategori tugas, pesan melalui `SnackBar`, dan tampilan ketika daftar masih kosong.

## Tugas

Tugas pertemuan ini berupa aplikasi daftar belanja. Pengguna dapat memasukkan nama barang, memilih kategori, menambahkan barang ke daftar, menandai atau menghapus barang, serta melakukan validasi sebelum data ditambahkan.

Pengelolaan state digunakan agar perubahan pada daftar belanja dapat ditampilkan secara langsung tanpa harus membuka ulang halaman.

## Tujuan Praktikum

Setelah menyelesaikan praktikum ini, saya diharapkan mampu menerima input pengguna, memeriksa validitas data, serta mengelola perubahan data menggunakan state management di Flutter.

## Struktur Folder

- `praktikum/bagian_a/` — TextField dan controller.
- `praktikum/bagian_b/` — Form dan validasi.
- `praktikum/bagian_c/` — Dasar state management.
- `praktikum/bagian_d/` — ChangeNotifier dan Provider.
- `tugas/` — Berisi kode tugas pertemuan ketiga.
- `doc-tugas/` — Tempat menyimpan dokumentasi atau laporan tugas.
- `README.md` — Penjelasan materi dan isi folder pertemuan.

## Kesimpulan

Dari praktikum ini, saya belajar bahwa input pengguna perlu dikelola dan divalidasi sebelum digunakan. Saya juga memahami bahwa state management membantu aplikasi memperbarui tampilan ketika data berubah. Materi ini berguna untuk membuat aplikasi yang lebih interaktif dan memiliki fungsi yang lebih lengkap.
