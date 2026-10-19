import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: DetailPenggunaPage(
      pengguna: Pengguna(
        name: 'Leanne Graham',
        email: 'leanne@example.com',
        phone: '1-770-736-8031',
        website: 'hildegard.org',
      ),
    )));

class Pengguna {
  final String name;
  final String email;
  final String phone;
  final String website;

  const Pengguna({
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
  });
}

class DetailPenggunaPage extends StatelessWidget {
  final Pengguna pengguna;
  const DetailPenggunaPage({super.key, required this.pengguna});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pengguna.name)),
      body: ListView(
        children: [
          ListTile(leading: const Icon(Icons.email), title: Text(pengguna.email)),
          ListTile(leading: const Icon(Icons.phone), title: Text(pengguna.phone)),
          ListTile(leading: const Icon(Icons.language), title: Text(pengguna.website)),
        ],
      ),
    );
  }
}
