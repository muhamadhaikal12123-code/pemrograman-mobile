import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PenggunaPage(),
  ));
}

class Pengguna {
  final int id;
  final String nama;
  final String email;

  Pengguna({required this.id, required this.nama, required this.email});

  factory Pengguna.fromJson(Map<String, dynamic> json) {
    return Pengguna(
      id: json['id'],
      nama: json['name'],
      email: json['email'],
    );
  }
}

Future<List<Pengguna>> ambilPengguna() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((item) => Pengguna.fromJson(item)).toList();
  } else {
    throw Exception('Gagal mengambil data pengguna');
  }
}

class PenggunaPage extends StatelessWidget {
  const PenggunaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Praktikum 4 - Bagian C')),
      body: FutureBuilder<List<Pengguna>>(
        future: ambilPengguna(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final pengguna = snapshot.data ?? [];
          return ListView.builder(
            itemCount: pengguna.length,
            itemBuilder: (context, index) {
              final item = pengguna[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${item.id}')),
                title: Text(item.nama),
                subtitle: Text(item.email),
              );
            },
          );
        },
      ),
    );
  }
}
