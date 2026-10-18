
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum C',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const StatePage(),
    );
  }
}

class StatePage extends StatefulWidget {
  const StatePage({super.key});

  @override
  State<StatePage> createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {
  int _jumlah = 0;
  String _nama = 'Haikal';

  void _tambah() {
    setState(() {
      _jumlah++;
    });
  }

  void _kurang() {
    setState(() {
      if (_jumlah > 0) {
        _jumlah--;
      }
    });
  }

  void _reset() {
    setState(() {
      _jumlah = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum C - State Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Muhamad Haikal Umardi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('NIM: 20240801169'),
            const Text('Program Studi: Teknik Informatika'),
            const SizedBox(height: 32),

            const Icon(
              Icons.touch_app,
              size: 70,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),

            Text(
              'Halo, $_nama!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 16),

            const Text(
              'Jumlah Klik',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '$_jumlah',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _tambah,
              icon: const Icon(Icons.add),
              label: const Text('Tambah'),
            ),
            const SizedBox(height: 8),

            OutlinedButton.icon(
              onPressed: _jumlah > 0 ? _kurang : null,
              icon: const Icon(Icons.remove),
              label: const Text('Kurangi'),
            ),
            const SizedBox(height: 8),

            TextButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
