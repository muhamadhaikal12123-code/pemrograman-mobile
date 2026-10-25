# Flutter Pertemuan 6

**Nama:** Muhamad Haikal Umardi  
**NIM:** 20240801169  
**Program Studi:** Teknik Informatika

## Deskripsi Proyek

Proyek ini merupakan tugas praktikum Flutter Pertemuan 6 yang membahas tema aplikasi, routing dan navigasi, serta animasi. Proyek dibagi menjadi empat bagian praktikum dan satu Tugas Mandiri.

## Struktur Folder

```text
pertemuan-6/
├── lib/
│   └── main.dart
├── praktikum/
│   ├── README.md
│   ├── bagian_a/
│   │   ├── README.md
│   │   └── main.dart
│   ├── bagian_b/
│   │   ├── README.md
│   │   └── main.dart
│   ├── bagian_c/
│   │   ├── README.md
│   │   └── main.dart
│   └── bagian_d/
│       ├── README.md
│       └── main.dart
├── tugas/
│   ├── README.md
│   └── main.dart
├── pubspec.yaml
└── README.md
```

## Pembagian Praktikum

1. **Bagian A:** Tema terang, tema gelap, dan warna tema.
2. **Bagian B:** Routing dan navigasi antarhalaman.
3. **Bagian C:** Navigasi tab menggunakan `NavigationBar` dan `IndexedStack`.
4. **Bagian D:** Animasi Flutter, termasuk animasi implisit dan eksplisit.
5. **Tugas Mandiri:** Aplikasi katalog produk dengan tema, navigasi, dan animasi.

## Persiapan

Pastikan Flutter SDK sudah terpasang dan buka terminal di folder proyek.

Jalankan:

```powershell
flutter pub get
flutter analyze
```

## Menjalankan Praktikum

Untuk menjalankan bagian tertentu, salin file `main.dart` dari bagian tersebut ke folder `lib`.

Contoh Bagian A:

```powershell
Copy-Item .\praktikum\bagian_a\main.dart .\lib\main.dart -Force
flutter run -d chrome
```

Ganti `bagian_a` menjadi `bagian_b`, `bagian_c`, atau `bagian_d` sesuai kebutuhan.

## Menjalankan Tugas Mandiri

```powershell
Copy-Item .\tugas\main.dart .\lib\main.dart -Force
flutter pub get
flutter run -d chrome
```

## Pemeriksaan Kode

Gunakan perintah berikut untuk memeriksa kode:

```powershell
flutter analyze
```

Hasil pemeriksaan sebelumnya menunjukkan `No issues found!`.

## Catatan

Setiap bagian praktikum dan Tugas Mandiri memiliki file kode masing-masing. File `lib/main.dart` digunakan sebagai titik masuk aplikasi saat dijalankan. Pastikan perubahan kode disimpan sebelum menjalankan ulang aplikasi.