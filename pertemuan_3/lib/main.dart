
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'praktikum/bagian_a/main.dart' as bagian_a;
import 'praktikum/bagian_b/main.dart' as bagian_b;
import 'praktikum/bagian_c/main.dart' as bagian_c;
import 'praktikum/bagian_d/main.dart' as bagian_d;
import 'tugas/main.dart' as tugas;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pertemuan 3',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void bukaHalaman(BuildContext context, Widget halaman) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => halaman,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pertemuan 3'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 24),

          _menu(
            context,
            judul: 'Praktikum A - Input Dasar',
            icon: Icons.edit,
            halaman: const bagian_a.InputPage(),
          ),

          _menu(
            context,
            judul: 'Praktikum B - Form Validation',
            icon: Icons.assignment,
            halaman: const bagian_b.FormPage(),
          ),

          _menu(
            context,
            judul: 'Praktikum C - State Management',
            icon: Icons.touch_app,
            halaman: const bagian_c.StatePage(),
          ),

          _menu(
            context,
            judul: 'Praktikum D - To-Do List',
            icon: Icons.checklist,
            halaman: const bagian_d.TodoPage(),
          ),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.shopping_cart,
                color: Colors.blue,
              ),
              title: const Text('Tugas - Shopping List'),
              subtitle: const Text('Kelola daftar belanja'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                bukaHalaman(
                  context,
                  ChangeNotifierProvider(
                    create: (_) => tugas.ShoppingProvider(),
                    child: const MaterialApp(
                      debugShowCheckedModeBanner: false,
                      home: tugas.ShoppingPage(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _menu(
    BuildContext context, {
    required String judul,
    required IconData icon,
    required Widget halaman,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(judul),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => bukaHalaman(context, halaman),
      ),
    );
  }
}
