import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DaftarPostinganPage(),
  ));
}

class DaftarPostinganPage extends StatefulWidget {
  const DaftarPostinganPage({super.key});

  @override
  State<DaftarPostinganPage> createState() => _DaftarPostinganPageState();
}

class _DaftarPostinganPageState extends State<DaftarPostinganPage> {
  late Future<List<dynamic>> futurePostingan;

  @override
  void initState() {
    super.initState();
    futurePostingan = ambilPostingan();
  }

  Future<List<dynamic>> ambilPostingan() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Gagal mengambil postingan');
  }

  void muatUlang() {
    setState(() => futurePostingan = ambilPostingan());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Postingan'),
        actions: [
          IconButton(onPressed: muatUlang, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futurePostingan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Gagal memuat data: ${snapshot.error}'),
                  ElevatedButton(onPressed: muatUlang, child: const Text('Coba Lagi')),
                ],
              ),
            );
          }
          final postingan = snapshot.data ?? [];
          return ListView.builder(
            itemCount: postingan.length,
            itemBuilder: (context, index) {
              final item = postingan[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(child: Text('${item['id']}')),
                  title: Text(item['title']),
                  subtitle: Text(
                    item['body'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPostinganPage(postingan: item),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailPostinganPage extends StatefulWidget {
  final Map<String, dynamic> postingan;
  const DetailPostinganPage({super.key, required this.postingan});

  @override
  State<DetailPostinganPage> createState() => _DetailPostinganPageState();
}

class _DetailPostinganPageState extends State<DetailPostinganPage> {
  late Future<List<dynamic>> futureKomentar;

  @override
  void initState() {
    super.initState();
    futureKomentar = ambilKomentar();
  }

  Future<List<dynamic>> ambilKomentar() async {
    final id = widget.postingan['id'];
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/$id/comments'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Gagal mengambil komentar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Postingan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.postingan['title'],
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(widget.postingan['body']),
          const Divider(height: 32),
          Text('Komentar', style: Theme.of(context).textTheme.titleLarge),
          FutureBuilder<List<dynamic>>(
            future: futureKomentar,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Text('Gagal memuat komentar: ${snapshot.error}');
              }
              final komentar = snapshot.data ?? [];
              return Column(
                children: komentar.map((item) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item['name']),
                    subtitle: Text('${item['email']}\n${item['body']}'),
                    isThreeLine: true,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
