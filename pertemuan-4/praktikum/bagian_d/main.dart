import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DaftarPenggunaPage(),
  ));
}

class DaftarPenggunaPage extends StatefulWidget {
  const DaftarPenggunaPage({super.key});

  @override
  State<DaftarPenggunaPage> createState() => _DaftarPenggunaPageState();
}

class _DaftarPenggunaPageState extends State<DaftarPenggunaPage> {
  late Future<List<dynamic>> futurePengguna;

  Future<List<dynamic>> ambilPengguna() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat pengguna');
    }
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    super.initState();
    futurePengguna = ambilPengguna();
  }

  void muatUlang() {
    setState(() {
      futurePengguna = ambilPengguna();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengguna'),
        actions: [IconButton(onPressed: muatUlang, icon: const Icon(Icons.refresh))],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futurePengguna,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Terjadi kesalahan: ${snapshot.error}'),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: muatUlang, child: const Text('Coba Lagi')),
                ],
              ),
            );
          }
          final data = snapshot.data ?? [];
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final pengguna = data[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${pengguna['id']}')),
                title: Text(pengguna['name']),
                subtitle: Text(pengguna['email']),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPenggunaPage(pengguna: pengguna),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class DetailPenggunaPage extends StatelessWidget {
  final Map<String, dynamic> pengguna;
  const DetailPenggunaPage({super.key, required this.pengguna});

  @override
  Widget build(BuildContext context) {
    final alamat = pengguna['address'];
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pengguna')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pengguna['name'], style: Theme.of(context).textTheme.headlineSmall),
            Text('Email: ${pengguna['email']}'),
            Text('Telepon: ${pengguna['phone']}'),
            Text('Website: ${pengguna['website']}'),
            Text('Kota: ${alamat['city']}'),
          ],
        ),
      ),
    );
  }
}
