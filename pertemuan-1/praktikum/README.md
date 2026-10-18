# LAPORAN PRAKTIKUM PEMROGRAMAN MOBILE
## Pertemuan 1 — Pengenalan Flutter

**Nama:** Muhamad Haikal Umardi  
**NIM:** 20240801169  
**Program Studi:** Teknik Informatika  
**Mata Kuliah:** Pemrograman Mobile

---

## 1. Tujuan Pembelajaran

Praktikum ini bertujuan untuk mengenal Flutter sebagai framework untuk membuat aplikasi mobile. Selain itu, praktikum ini membantu memahami cara menyiapkan lingkungan pengembangan, membuat project Flutter, mengenali struktur folder, serta mempelajari penggunaan widget dasar pada Flutter.

Tujuan yang ingin dicapai:
- Memahami pengertian Flutter dan bahasa pemrograman Dart.
- Mengetahui cara memeriksa instalasi Flutter.
- Membuat project Flutter pertama.
- Memahami struktur folder pada project Flutter.
- Mempelajari penggunaan widget dasar.
- Membuat tampilan sederhana dan aplikasi penghitung angka.

## 2. Alat dan Bahan

Perangkat dan aplikasi yang digunakan dalam praktikum ini adalah:

| No. | Alat atau Bahan | Keterangan |
|---|---|---|
| 1 | Laptop | Perangkat untuk menjalankan praktikum |
| 2 | Visual Studio Code | Editor untuk menulis kode program |
| 3 | Flutter SDK | Framework pengembangan aplikasi |
| 4 | Dart | Bahasa pemrograman Flutter |
| 5 | Android SDK | Perangkat pendukung pengembangan Android |
| 6 | Android Emulator | Menjalankan aplikasi Android secara virtual |

**Lokasi project:** `C:\Pemob\PERTEMUAN 1\praktikum`

## 3. Dasar Teori

### 3.1 Flutter

Flutter merupakan framework dari Google yang digunakan untuk membangun aplikasi menggunakan satu basis kode. Flutter dapat digunakan untuk mengembangkan aplikasi Android, iOS, web, dan desktop.

### 3.2 Dart

Dart adalah bahasa pemrograman yang digunakan untuk membuat aplikasi Flutter. Bahasa ini mendukung pemrograman berorientasi objek dan memiliki sintaks yang mudah dipelajari.

### 3.3 Widget

Widget merupakan komponen utama untuk membangun tampilan aplikasi Flutter. Teks, tombol, gambar, ikon, dan tata letak dapat dibuat menggunakan widget.

### 3.4 StatelessWidget

StatelessWidget digunakan untuk membuat tampilan yang tidak menyimpan perubahan keadaan secara langsung. Widget ini cocok untuk elemen tampilan yang relatif tetap.

### 3.5 StatefulWidget

StatefulWidget digunakan ketika tampilan perlu berubah berdasarkan keadaan tertentu, misalnya ketika angka penghitung bertambah setelah tombol ditekan.

### 3.6 Hot Reload

Hot Reload merupakan fitur Flutter yang memungkinkan perubahan kode ditampilkan dengan cepat tanpa harus menjalankan ulang aplikasi dari awal pada banyak kondisi.

## 4. Langkah-Langkah Praktikum

### A. Pemeriksaan Instalasi Flutter

Langkah pertama adalah memastikan Flutter sudah terpasang dan dapat digunakan.

Perintah yang digunakan:

```bash
flutter --version
flutter doctor
flutter devices
```

Keterangan:
- `flutter --version` digunakan untuk melihat versi Flutter.
- `flutter doctor` digunakan untuk memeriksa kebutuhan pengembangan.
- `flutter devices` digunakan untuk melihat perangkat yang dapat menjalankan aplikasi.

### B. Membuat Project Flutter

Project Flutter dapat dibuat menggunakan perintah:

```bash
flutter create praktikum_1
cd praktikum_1
```

Pada project yang sudah tersedia, perintah `flutter create .` dapat digunakan untuk melengkapi konfigurasi Flutter pada folder tersebut.

Setelah project siap, buka folder project menggunakan Visual Studio Code.

### C. Mengenal Struktur Project

Beberapa folder dan file penting dalam project Flutter adalah:

| File atau Folder | Fungsi |
|---|---|
| `lib/` | Menyimpan kode utama aplikasi |
| `lib/main.dart` | Titik awal program Flutter |
| `android/` | Konfigurasi khusus Android |
| `ios/` | Konfigurasi khusus iOS |
| `web/` | File pendukung aplikasi web |
| `test/` | Menyimpan file pengujian |
| `pubspec.yaml` | Mengatur dependensi dan aset project |
| `README.md` | Berisi dokumentasi project |

### D. Membuat Tampilan Hello Flutter

Pada tahap ini, aplikasi dibuat dengan menampilkan AppBar dan teks sederhana.

Contoh kode:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello Flutter'),
        ),
        body: const Center(
          child: Text(
            'Halo, nama saya Muhamad Haikal Umardi!',
          ),
        ),
      ),
    );
  }
}
```

**Penjelasan:**
- `main()` merupakan fungsi pertama yang dijalankan.
- `runApp()` digunakan untuk menjalankan aplikasi.
- `MaterialApp` menyediakan struktur dasar aplikasi.
- `Scaffold` menyediakan kerangka halaman.
- `AppBar` menampilkan bagian atas halaman.
- `Center` menempatkan widget di tengah.
- `Text` digunakan untuk menampilkan tulisan.

### E. Membuat Layout Sederhana

Layout digunakan untuk mengatur posisi dan susunan komponen pada aplikasi. Flutter menyediakan berbagai widget layout, seperti `Column`, `Row`, `Container`, dan `Center`.

Contoh penggunaan:

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    Text('Selamat Datang'),
    Text('Praktikum Flutter'),
  ],
)
```

Kode tersebut menampilkan dua teks secara vertikal menggunakan `Column`.

### F. Membuat Aplikasi Counter

Aplikasi Counter merupakan contoh penggunaan StatefulWidget untuk mengubah angka melalui tombol.

Contoh kode:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int angka = 0;

  void tambahAngka() {
    setState(() {
      angka++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Jumlah tombol ditekan:'),
            Text(
              '$angka',
              style: const TextStyle(fontSize: 30),
            ),
            ElevatedButton(
              onPressed: tambahAngka,
              child: const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan:**
- `StatefulWidget` digunakan karena angka dapat berubah.
- Variabel `angka` menyimpan nilai penghitung.
- Fungsi `tambahAngka()` digunakan untuk menambah nilai.
- `setState()` memberi tahu Flutter bahwa tampilan perlu diperbarui.
- `ElevatedButton` menyediakan tombol untuk menjalankan fungsi.

## 5. Latihan Mandiri

Latihan mandiri dilakukan untuk meningkatkan pemahaman mengenai widget dan logika dasar Flutter.

### Latihan 1 — Mengubah Teks

Mengganti teks awal aplikasi dengan nama sendiri dan tulisan sesuai kebutuhan.

### Latihan 2 — Mengubah Tampilan

Mengatur ukuran tulisan, warna teks, dan posisi komponen menggunakan widget yang tersedia.

### Latihan 3 — Menambahkan Komponen

Menambahkan beberapa widget seperti `Text`, `Icon`, dan `ElevatedButton` pada halaman aplikasi.

### Latihan 4 — Mengembangkan Counter

Mengembangkan aplikasi Counter dengan menambahkan fitur untuk mengurangi angka atau mengembalikan nilai ke nol.

## 6. Tugas Praktikum

Tugas praktikum berupa pembuatan tampilan kartu perkenalan sederhana menggunakan Flutter.

Informasi yang ditampilkan:
- Nama: Muhamad Haikal Umardi
- NIM: 20240801169
- Program Studi: Teknik Informatika
- Hobi: Bermain sepak bola

Komponen yang dapat digunakan adalah `Card`, `Column`, `Text`, dan `Icon`. Tampilan dibuat agar informasi mudah dibaca dan tersusun rapi.

## 7. Hasil yang Diharapkan

Setelah menyelesaikan praktikum, mahasiswa diharapkan mampu:
1. Memeriksa kesiapan lingkungan pengembangan Flutter.
2. Membuat dan menjalankan project Flutter.
3. Menjelaskan fungsi file dan folder utama.
4. Membuat tampilan menggunakan widget dasar.
5. Memahami perbedaan StatelessWidget dan StatefulWidget.
6. Membuat aplikasi sederhana yang memiliki interaksi.

## 8. Pertanyaan dan Refleksi

**1. Apa yang dimaksud dengan Flutter?**

Flutter adalah framework yang digunakan untuk mengembangkan aplikasi pada berbagai platform menggunakan satu basis kode.

**2. Apa fungsi Dart dalam Flutter?**

Dart digunakan untuk menulis logika program dan membangun komponen aplikasi Flutter.

**3. Apa perbedaan StatelessWidget dan StatefulWidget?**

StatelessWidget digunakan untuk tampilan yang tidak bergantung pada perubahan state, sedangkan StatefulWidget digunakan ketika tampilan perlu diperbarui berdasarkan perubahan state.

**4. Apa fungsi `setState()`?**

`setState()` digunakan untuk memberi tahu Flutter bahwa state berubah sehingga tampilan dapat diperbarui.

**5. Apa fungsi file `main.dart`?**

File `main.dart` biasanya menjadi titik awal program Flutter dijalankan.

## 9. Troubleshooting

Beberapa kendala yang dapat terjadi saat praktikum antara lain:

| Kendala | Solusi |
|---|---|
| Perintah Flutter tidak dikenali | Periksa lokasi Flutter SDK dan konfigurasi PATH |
| Emulator tidak terdeteksi | Jalankan emulator dan periksa dengan `flutter devices` |
| Aplikasi gagal dijalankan | Periksa pesan error pada terminal |
| Tampilan tidak berubah | Periksa kode dan pastikan perubahan tersimpan |
| Dependensi bermasalah | Jalankan `flutter pub get` |

## 10. Referensi

1. Dokumentasi resmi Flutter: https://docs.flutter.dev/
2. Dokumentasi bahasa Dart: https://dart.dev/
3. Dokumentasi widget Flutter: https://api.flutter.dev/
4. Dokumentasi Visual Studio Code: https://code.visualstudio.com/docs

## 11. Ringkasan Pertemuan

Pada pertemuan pertama, materi yang dipelajari meliputi pengenalan Flutter dan Dart, pemeriksaan instalasi, pembuatan project, pengenalan struktur folder, penggunaan widget dasar, serta pembuatan aplikasi Counter.

Praktikum ini menjadi dasar untuk mempelajari pengembangan aplikasi mobile menggunakan Flutter pada pertemuan selanjutnya.

## 12. Kesimpulan

Berdasarkan praktikum yang dilakukan, Flutter dapat digunakan untuk membuat aplikasi dengan menyusun berbagai widget. Pemahaman terhadap struktur project, fungsi `main.dart`, serta penggunaan StatelessWidget dan StatefulWidget menjadi dasar penting sebelum mengembangkan aplikasi yang lebih kompleks.

Melalui praktikum ini, mahasiswa diharapkan dapat membuat aplikasi sederhana dan memahami proses dasar pengembangan aplikasi mobile menggunakan Flutter.
