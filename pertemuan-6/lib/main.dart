import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

final modeTema = ValueNotifier<ThemeMode>(ThemeMode.light);
final warnaTema = ValueNotifier<Color>(Colors.indigo);

const warnaPilihan = [
  Colors.indigo,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

class Produk {
  final String nama;
  final String deskripsi;
  final int harga;
  final IconData ikon;
  final Color warna;

  const Produk(this.nama, this.deskripsi, this.harga, this.ikon, this.warna);
}

const produkList = [
  Produk('Laptop', 'Laptop untuk kuliah dan pekerjaan.', 7500000, Icons.laptop, Colors.indigo),
  Produk('Headphone', 'Headphone untuk musik dan hiburan.', 450000, Icons.headphones, Colors.teal),
  Produk('Kamera', 'Kamera untuk mengabadikan momen.', 3200000, Icons.camera_alt, Colors.deepOrange),
  Produk('Smartphone', 'Smartphone untuk kebutuhan sehari-hari.', 2800000, Icons.phone_android, Colors.pink),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([modeTema, warnaTema]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Katalog Interaktif',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: warnaTema.value,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: warnaTema.value,
            brightness: Brightness.dark,
          ),
          themeMode: modeTema.value,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            if (settings.name == '/') {
              return MaterialPageRoute(
                builder: (_) => const HalamanUtama(),
              );
            }

            if (settings.name == '/detail') {
              final produk = settings.arguments as Produk;
              return PageRouteBuilder(
                pageBuilder: (_, animation, secondaryAnimation) =>
                    DetailProduk(produk: produk),
                transitionsBuilder: (_, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            }

            return MaterialPageRoute(
              builder: (_) => const Halaman404(),
            );
          },
        );
      },
    );
  }
}

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int tabAktif = 0;
  final Set<String> keranjang = {};

  @override
  Widget build(BuildContext context) {
    final halaman = [
      BerandaTab(
        keranjang: keranjang,
        saatTambah: (produk) => setState(() => keranjang.add(produk.nama)),
      ),
      const AnimasiTab(),
      const PengaturanTab(),
    ];

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                'Katalog Interaktif',
                style: TextStyle(fontSize: 22),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                setState(() => tabAktif = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.animation),
              title: const Text('Animasi'),
              onTap: () {
                setState(() => tabAktif = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                setState(() => tabAktif = 2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: tabAktif, children: halaman),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabAktif,
        onDestinationSelected: (index) => setState(() => tabAktif = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Katalog',
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
  final Set<String> keranjang;
  final ValueChanged<Produk> saatTambah;

  const BerandaTab({
    super.key,
    required this.keranjang,
    required this.saatTambah,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Produk'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Badge(
              label: Text('${keranjang.length}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: produkList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final produk = produkList[index];

          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                '/detail',
                arguments: produk,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Hero(
                          tag: produk.nama,
                          child: Icon(
                            produk.ikon,
                            size: 65,
                            color: produk.warna,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      produk.nama,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${produk.harga}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => saatTambah(produk),
                        child: Text(
                          keranjang.contains(produk.nama) ? 'Ditambahkan' : 'Tambah',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailProduk extends StatelessWidget {
  final Produk produk;

  const DetailProduk({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: produk.nama,
                child: Icon(produk.ikon, size: 120, color: produk.warna),
              ),
              const SizedBox(height: 24),
              Text(
                produk.nama,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(produk.deskripsi, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(
                'Rp ${produk.harga}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
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

class _AnimasiTabState extends State<AnimasiTab>
    with SingleTickerProviderStateMixin {
  bool diperbesar = false;
  bool tampil = true;
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo Animasi')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: diperbesar ? 180 : 100,
              height: diperbesar ? 180 : 100,
              decoration: BoxDecoration(
                color: diperbesar ? Colors.teal : Colors.indigo,
                borderRadius: BorderRadius.circular(diperbesar ? 90 : 16),
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => setState(() => diperbesar = !diperbesar),
              child: const Text('Ubah Ukuran'),
            ),
            const SizedBox(height: 24),
            RotationTransition(
              turns: controller,
              child: const Icon(Icons.settings, size: 65),
            ),
            const SizedBox(height: 24),
            AnimatedOpacity(
              opacity: tampil ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: const Text('Animasi Opacity'),
            ),
            TextButton(
              onPressed: () => setState(() => tampil = !tampil),
              child: const Text('Tampilkan / Sembunyikan'),
            ),
          ],
        ),
      ),
    );
  }
}

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListenableBuilder(
            listenable: modeTema,
            builder: (context, _) {
              return SwitchListTile(
                title: const Text('Mode Gelap'),
                value: modeTema.value == ThemeMode.dark,
                onChanged: (value) {
                  modeTema.value =
                      value ? ThemeMode.dark : ThemeMode.light;
                },
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Pilih Warna Tema',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: warnaTema,
            builder: (context, _) {
              return Wrap(
                spacing: 12,
                children: [
                  for (final warna in warnaPilihan)
                    GestureDetector(
                      onTap: () => warnaTema.value = warna,
                      child: CircleAvatar(
                        backgroundColor: warna,
                        child: warnaTema.value == warna
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class Halaman404 extends StatelessWidget {
  const Halaman404({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: const Center(child: Text('Halaman tidak ditemukan')),
    );
  }
}
