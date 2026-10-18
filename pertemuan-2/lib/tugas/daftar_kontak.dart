
import 'package:flutter/material.dart';

class Kontak {
  final String nama;
  final String telepon;
  final String email;

  const Kontak(this.nama, this.telepon, this.email);
}

const daftarKontak = [
  Kontak('Andi', '081234567801', 'andi@email.com'),
  Kontak('Budi', '081234567802', 'budi@email.com'),
  Kontak('Citra', '081234567803', 'citra@email.com'),
  Kontak('Dewi', '081234567804', 'dewi@email.com'),
  Kontak('Eko', '081234567805', 'eko@email.com'),
  Kontak('Fitri', '081234567806', 'fitri@email.com'),
];

class DaftarKontakPage extends StatelessWidget {
  const DaftarKontakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kontak'),
      ),
      body: ListView.builder(
        itemCount: daftarKontak.length,
        itemBuilder: (context, index) {
          final kontak = daftarKontak[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(kontak.nama[0]),
              ),
              title: Text(kontak.nama),
              subtitle: Text(kontak.telepon),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailKontakPage(kontak: kontak),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailKontakPage extends StatelessWidget {
  final Kontak kontak;

  const DetailKontakPage({
    super.key,
    required this.kontak,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kontak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                child: Text(
                  kontak.nama[0],
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Nama: ${kontak.nama}'),
            const SizedBox(height: 12),
            Text('Nomor Telepon: ${kontak.telepon}'),
            const SizedBox(height: 12),
            Text('Email: ${kontak.email}'),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kembali'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
