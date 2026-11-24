import 'package:flutter/material.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.teal);

const pilihanWarna = [
  Colors.teal,
  Colors.indigo,
  Colors.deepOrange,
  Colors.purple,
];

ThemeData buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}

void main() => runApp(const KatalogWisataApp());

class KatalogWisataApp extends StatelessWidget {
  const KatalogWisataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Katalog Wisata Nusantara',
          debugShowCheckedModeBanner: false,
          theme: buatTema(seedColor.value, Brightness.light),
          darkTheme: buatTema(seedColor.value, Brightness.dark),
          themeMode: themeMode.value,
          initialRoute: '/',
          routes: {
            '/': (_) => const MainShellPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final destinasi = settings.arguments as Destinasi;
              return MaterialPageRoute(
                builder: (_) => DetailDestinasiPage(destinasi: destinasi),
                settings: settings,
              );
            }
            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Tidak Ditemukan')),
                body: const Center(
                  child: Text('404 - Halaman tidak ditemukan'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class Destinasi {
  final String id;
  final String nama;
  final String lokasi;
  final String deskripsi;
  final IconData ikon;

  const Destinasi({
    required this.id,
    required this.nama,
    required this.lokasi,
    required this.deskripsi,
    required this.ikon,
  });
}

const daftarDestinasi = [
  Destinasi(
    id: 'raja-ampat',
    nama: 'Raja Ampat',
    lokasi: 'Papua Barat Daya',
    deskripsi:
        'Kepulauan eksotis dengan gugusan pulau karang dan keanekaragaman hayati laut.',
    ikon: Icons.scuba_diving,
  ),
  Destinasi(
    id: 'bromo',
    nama: 'Gunung Bromo',
    lokasi: 'Jawa Timur',
    deskripsi:
        'Kawasan gunung berapi dengan lautan pasir luas dan panorama matahari terbit.',
    ikon: Icons.terrain,
  ),
  Destinasi(
    id: 'borobudur',
    nama: 'Candi Borobudur',
    lokasi: 'Jawa Tengah',
    deskripsi:
        'Situs warisan budaya dengan arsitektur berundak dan relief bersejarah.',
    ikon: Icons.temple_buddhist,
  ),
  Destinasi(
    id: 'komodo',
    nama: 'Pulau Komodo',
    lokasi: 'Nusa Tenggara Timur',
    deskripsi:
        'Habitat satwa komodo serta perbukitan savana dan pantai berpasir unik.',
    ikon: Icons.pets,
  ),
];

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _selectedIndex = 0;

  static const _pages = [
    KatalogTab(),
    AnimasiKatalogTab(),
    PengaturanTemaTab(),
  ];

  static const _titles = ['Katalog Wisata', 'Animasi Katalog', 'Pengaturan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Katalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
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
  const KatalogTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colors = tema.colorScheme;

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: daftarDestinasi.length,
      itemBuilder: (context, index) {
        final item = daftarDestinasi[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Hero(
              tag: 'destinasi-${item.id}',
              child: CircleAvatar(
                radius: 28,
                backgroundColor: colors.primaryContainer,
                child: Icon(item.ikon, color: colors.onPrimaryContainer),
              ),
            ),
            title: Text(item.nama, style: tema.textTheme.titleMedium),
            subtitle: Text(
              item.lokasi,
              style: tema.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: item);
            },
          ),
        );
      },
    );
  }
}

class DetailDestinasiPage extends StatelessWidget {
  final Destinasi destinasi;

  const DetailDestinasiPage({super.key, required this.destinasi});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colors = tema.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(destinasi.nama)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'destinasi-${destinasi.id}',
              child: CircleAvatar(
                radius: 72,
                backgroundColor: colors.primaryContainer,
                child: Icon(
                  destinasi.ikon,
                  size: 72,
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(destinasi.nama, style: tema.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(
              destinasi.lokasi,
              style: tema.textTheme.titleSmall?.copyWith(
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              destinasi.deskripsi,
              textAlign: TextAlign.center,
              style: tema.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class AnimasiKatalogTab extends StatefulWidget {
  const AnimasiKatalogTab({super.key});

  @override
  State<AnimasiKatalogTab> createState() => _AnimasiKatalogTabState();
}

class _AnimasiKatalogTabState extends State<AnimasiKatalogTab>
    with SingleTickerProviderStateMixin {
  bool _diperluas = false;
  late final AnimationController _kompasController;

  @override
  void initState() {
    super.initState();
    _kompasController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _kompasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colors = tema.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '1. Animasi Implisit (AnimatedContainer)',
          style: tema.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: _diperluas ? 260 : 180,
            height: 84,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _diperluas ? colors.primary : colors.secondaryContainer,
              borderRadius: BorderRadius.circular(_diperluas ? 32 : 12),
            ),
            child: Text(
              _diperluas ? 'Paket Jelajah Aktif' : 'Banner Promo',
              style: tema.textTheme.titleMedium?.copyWith(
                color:
                    _diperluas ? colors.onPrimary : colors.onSecondaryContainer,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _diperluas = !_diperluas),
          child: const Text('Ubah Tampilan Banner'),
        ),
        const Divider(),
        Text(
          '2. Animasi Eksplisit (AnimationController)',
          style: tema.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Center(
          child: RotationTransition(
            turns: _kompasController,
            child: Icon(Icons.explore, size: 64, color: colors.primary),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_kompasController.isAnimating) {
              _kompasController.stop();
            } else {
              _kompasController.repeat();
            }
            setState(() {});
          },
          child: Text(
            _kompasController.isAnimating ? 'Hentikan Putaran' : 'Putar Kompas',
          ),
        ),
      ],
    );
  }
}

class PengaturanTemaTab extends StatelessWidget {
  const PengaturanTemaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Mode Gelap'),
              value: themeMode.value == ThemeMode.dark,
              onChanged: (v) {
                themeMode.value = v ? ThemeMode.dark : ThemeMode.light;
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Pilihan Warna Tema',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                for (final c in pilihanWarna)
                  GestureDetector(
                    onTap: () => seedColor.value = c,
                    child: CircleAvatar(
                      backgroundColor: c,
                      child: seedColor.value == c
                          ? Icon(Icons.check, color: colors.onPrimary)
                          : null,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
