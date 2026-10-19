import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FutureDemoPage(),
  ));
}

class FutureDemoPage extends StatelessWidget {
  const FutureDemoPage({super.key});

  Future<String> ambilData() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Data berhasil dimuat!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Praktikum 4 - Bagian A')),
      body: Center(
        child: FutureBuilder<String>(
          future: ambilData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Terjadi error: ${snapshot.error}');
            }
            return Text(
              snapshot.data ?? 'Tidak ada data',
              style: const TextStyle(fontSize: 20),
            );
          },
        ),
      ),
    );
  }
}
