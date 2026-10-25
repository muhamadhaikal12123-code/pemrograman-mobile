import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HalamanUtama(),
    );
  }
}

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int halamanAktif = 0;

  final List<Widget> halaman = const [
    BerandaTab(),
    AnimasiTab(),
    PengaturanTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: halamanAktif,
        children: halaman,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: halamanAktif,
        onDestinationSelected: (index) {
          setState(() => halamanAktif = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.animation_outlined),
            selectedIcon: Icon(Icons.animation),
            label: 'Animasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 80),
            SizedBox(height: 12),
            Text('Selamat datang di Praktikum Flutter 6'),
          ],
        ),
      ),
    );
  }
}

class AnimasiTab extends StatefulWidget {
  const AnimasiTab({super.key});

  @override
  State<AnimasiTab> createState() => _AnimasiTabState();
}

class _AnimasiTabState extends State<AnimasiTab> {
  bool aktif = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animasi')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: aktif ? 180 : 100,
              height: aktif ? 180 : 100,
              decoration: BoxDecoration(
                color: aktif ? Colors.teal : Colors.indigo,
                borderRadius: BorderRadius.circular(aktif ? 90 : 16),
              ),
              child: const Icon(
                Icons.star,
                color: Colors.white,
                size: 45,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() => aktif = !aktif),
              child: const Text('Jalankan Animasi'),
            ),
          ],
        ),
      ),
    );
  }
}

class PengaturanTab extends StatefulWidget {
  const PengaturanTab({super.key});

  @override
  State<PengaturanTab> createState() => _PengaturanTabState();
}

class _PengaturanTabState extends State<PengaturanTab> {
  bool notifikasi = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: SwitchListTile(
        title: const Text('Aktifkan notifikasi'),
        value: notifikasi,
        onChanged: (value) {
          setState(() => notifikasi = value);
        },
      ),
    );
  }
}
