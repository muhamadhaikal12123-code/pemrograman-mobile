import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class Item {
  final String nama;
  final String deskripsi;
  final Color warna;
  final IconData ikon;

  const Item(this.nama, this.deskripsi, this.warna, this.ikon);
}

const daftarItem = [
  Item('Laptop', 'Laptop untuk belajar dan bekerja.', Colors.indigo, Icons.laptop),
  Item('Headphone', 'Headphone untuk mendengarkan musik.', Colors.teal, Icons.headphones),
  Item('Kamera', 'Kamera untuk mengambil foto.', Colors.deepOrange, Icons.camera_alt),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routing dan Navigasi',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (_) => const DaftarPage(),
          );
        }

        if (settings.name == '/detail') {
          final item = settings.arguments as Item;
          return MaterialPageRoute(
            builder: (_) => DetailPage(item: item),
          );
        }

        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Halaman tidak ditemukan')),
          ),
        );
      },
    );
  }
}

class DaftarPage extends StatelessWidget {
  const DaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Barang')),
      body: ListView.builder(
        itemCount: daftarItem.length,
        itemBuilder: (context, index) {
          final item = daftarItem[index];
          return ListTile(
            leading: Hero(
              tag: item.nama,
              child: CircleAvatar(
                backgroundColor: item.warna,
                child: Icon(item.ikon, color: Colors.white),
              ),
            ),
            title: Text(item.nama),
            subtitle: Text(item.deskripsi),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: item,
              );
            },
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Item item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Barang')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: item.nama,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: item.warna,
                child: Icon(item.ikon, size: 55, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              item.nama,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                item.deskripsi,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
