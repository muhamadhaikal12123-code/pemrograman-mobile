
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

const warnaPilihan = <Color>[
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

  const Produk({
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.ikon,
    required this.warna,
  });
}

const produkList = <Produk>[
  Produk(
    nama: 'Laptop',
    deskripsi: 'Laptop untuk belajar dan bekerja.',
    harga: 7500000,
    ikon: Icons.laptop,
    warna: Colors.indigo,
  ),
  Produk(
    nama: 'Headphone',
    deskripsi: 'Headphone untuk musik dan hiburan.',
    harga: 450000,
    ikon: Icons.headphones,
    warna: Colors.teal,
  ),
  Produk(
    nama: 'Kamera',
    deskripsi: 'Kamera untuk mengabadikan momen.',
    harga: 3200000,
    ikon: Icons.camera_alt,
    warna: Colors.deepOrange,
  ),
  Produk(
    nama: 'Smartphone',
    deskripsi: 'Smartphone untuk kebutuhan sehari-hari.',
    harga: 2800000,
    ikon: Icons.phone_android,
    warna: Colors.pink,
  ),
];

String formatRupiah(int harga) {
  return 'Rp ${harga.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  )}';
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode modeTema = ThemeMode.light;
  Color warnaTema = Colors.indigo;
  bool selesaiMemuat = false;

  @override
  void initState() {
    super.initState();
    muatTema();
  }

  Future<void> muatTema() async {
    final prefs = await SharedPreferences.getInstance();
    final gelap = prefs.getBool('mode_gelap') ?? false;
    final nilaiWarna = prefs.getInt('warna_tema') ?? Colors.indigo.toARGB32();

    if (!mounted) return;

    setState(() {
      modeTema = gelap ? ThemeMode.dark : ThemeMode.light;
      warnaTema = Color(nilaiWarna);
      selesaiMemuat = true;
    });
  }

  Future<void> simpanTema() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('mode_gelap', modeTema == ThemeMode.dark);
    await prefs.setInt('warna_tema', warnaTema.toARGB32());
  }

  void ubahMode(bool gelap) {
    setState(() {
      modeTema = gelap ? ThemeMode.dark : ThemeMode.light;
    });
    simpanTema();
  }

  void ubahWarna(Color warna) {
    setState(() {
      warnaTema = warna;
    });
    simpanTema();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katalog Interaktif',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: warnaTema,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: warnaTema,
        brightness: Brightness.dark,
      ),
      themeMode: modeTema,
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final produk = settings.arguments as Produk;
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, animation, secondaryAnimation) {
              return DetailProduk(produk: produk);
            },
            transitionsBuilder: (_, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        }

        if (settings.name == '/keranjang') {
          final isi = settings.arguments as Map<String, int>;
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => HalamanKeranjang(isi: isi),
          );
        }

        return null;
      },
      home: selesaiMemuat
          ? HalamanUtama(
              modeTema: modeTema,
              warnaTema: warnaTema,
              ubahMode: ubahMode,
              ubahWarna: ubahWarna,
            )
          : const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
    );
  }
}

class HalamanUtama extends StatefulWidget {
  final ThemeMode modeTema;
  final Color warnaTema;
  final ValueChanged<bool> ubahMode;
  final ValueChanged<Color> ubahWarna;

  const HalamanUtama({
    super.key,
    required this.modeTema,
    required this.warnaTema,
    required this.ubahMode,
    required this.ubahWarna,
  });

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int tabAktif = 0;
  final Map<String, int> keranjang = {};

  void tambahProduk(Produk produk) {
    setState(() {
      keranjang.update(
        produk.nama,
        (jumlah) => jumlah + 1,
        ifAbsent: () => 1,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produk.nama} ditambahkan ke keranjang'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  int get jumlahKeranjang =>
      keranjang.values.fold(0, (total, jumlah) => total + jumlah);

  @override
  Widget build(BuildContext context) {
    final halaman = [
      KatalogTab(
        keranjang: keranjang,
        jumlahKeranjang: jumlahKeranjang,
        tambahProduk: tambahProduk,
      ),
      const AnimasiTab(),
      PengaturanTab(
        modeTema: widget.modeTema,
        warnaTema: widget.warnaTema,
        ubahMode: widget.ubahMode,
        ubahWarna: widget.ubahWarna,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: tabAktif,
        children: halaman,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabAktif,
        onDestinationSelected: (index) {
          setState(() => tabAktif = index);
        },
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

class KatalogTab extends StatelessWidget {
  final Map<String, int> keranjang;
  final int jumlahKeranjang;
  final ValueChanged<Produk> tambahProduk;

  const KatalogTab({
    super.key,
    required this.keranjang,
    required this.jumlahKeranjang,
    required this.tambahProduk,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Produk'),
        actions: [
          IconButton(
            tooltip: 'Buka keranjang',
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/keranjang',
                arguments: Map<String, int>.from(keranjang),
              );
            },
            icon: Badge(
              label: Text('$jumlahKeranjang'),
              isLabelVisible: jumlahKeranjang > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final kolom = constraints.maxWidth >= 900
              ? 4
              : constraints.maxWidth >= 600
                  ? 3
                  : 2;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: produkList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: kolom,
              childAspectRatio: 0.72,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemBuilder: (context, index) {
              final produk = produkList[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: produk,
                    );
                  },
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
                                size: 64,
                                color: produk.warna,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          produk.nama,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatRupiah(produk.harga),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => tambahProduk(produk),
                            child: Text(
                              keranjang.containsKey(produk.nama)
                                  ? 'Tambah lagi'
                                  : 'Tambah',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
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
              Text(
                produk.deskripsi,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                formatRupiah(produk.harga),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              const Text('Gunakan tombol kembali untuk ke katalog.'),
            ],
          ),
        ),
      ),
    );
  }
}

class HalamanKeranjang extends StatelessWidget {
  final Map<String, int> isi;

  const HalamanKeranjang({super.key, required this.isi});

  @override
  Widget build(BuildContext context) {
    final daftarIsi = produkList
        .where((produk) => isi.containsKey(produk.nama))
        .toList();

    final total = daftarIsi.fold<int>(
      0,
      (jumlah, produk) => jumlah + produk.harga * isi[produk.nama]!,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: daftarIsi.isEmpty
          ? const Center(child: Text('Keranjang masih kosong'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final produk in daftarIsi)
                  ListTile(
                    leading: Icon(produk.ikon, color: produk.warna, size: 36),
                    title: Text(produk.nama),
                    subtitle: Text(
                      '${isi[produk.nama]} x ${formatRupiah(produk.harga)}',
                    ),
                    trailing: Text(
                      formatRupiah(produk.harga * isi[produk.nama]!),
                    ),
                  ),
                const Divider(),
                ListTile(
                  title: const Text('Total'),
                  titleTextStyle: Theme.of(context).textTheme.titleLarge,
                  trailing: Text(
                    formatRupiah(total),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ini merupakan simulasi keranjang. Pembayaran belum terhubung.',
                  textAlign: TextAlign.center,
                ),
              ],
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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
                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 50,
                ),
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
              const SizedBox(height: 20),
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
      ),
    );
  }
}

class PengaturanTab extends StatelessWidget {
  final ThemeMode modeTema;
  final Color warnaTema;
  final ValueChanged<bool> ubahMode;
  final ValueChanged<Color> ubahWarna;

  const PengaturanTab({
    super.key,
    required this.modeTema,
    required this.warnaTema,
    required this.ubahMode,
    required this.ubahWarna,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Mode Gelap'),
            subtitle: const Text('Pilihan disimpan otomatis'),
            value: modeTema == ThemeMode.dark,
            onChanged: ubahMode,
          ),
          const SizedBox(height: 20),
          Text(
            'Pilih Warna Tema',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 14,
            children: [
              for (final warna in warnaPilihan)
                GestureDetector(
                  onTap: () => ubahWarna(warna),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: warna,
                    child: warnaTema == warna
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
