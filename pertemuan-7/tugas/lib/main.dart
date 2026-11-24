import 'package:flutter/material.dart';
import 'models/kegiatan.dart';
import 'pages/form_kegiatan_page.dart';
import 'pages/shell_page.dart';
import 'state/pengaturan.dart';

ThemeData buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PengaturanState.muat();
  runApp(const TabungKuApp());
}

class TabungKuApp extends StatelessWidget {
  const TabungKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        PengaturanState.themeMode,
        PengaturanState.seedColor,
      ]),
      builder: (context, _) {
        return MaterialApp(
          title: 'TabungKu',
          debugShowCheckedModeBanner: false,
          theme: buatTema(PengaturanState.seedColor.value, Brightness.light),
          darkTheme: buatTema(PengaturanState.seedColor.value, Brightness.dark),
          themeMode: PengaturanState.themeMode.value,
          initialRoute: '/',
          routes: {
            '/': (_) => const ShellPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/form') {
              final kegiatan = settings.arguments as Kegiatan?;
              return MaterialPageRoute(
                builder: (_) => FormKegiatanPage(kegiatanEdit: kegiatan),
                settings: settings,
              );
            }
            return null;
          },
        );
      },
    );
  }
}
