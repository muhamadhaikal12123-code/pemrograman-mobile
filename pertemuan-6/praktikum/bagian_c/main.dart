import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Animasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const AnimasiPage(),
    );
  }
}

class AnimasiPage extends StatefulWidget {
  const AnimasiPage({super.key});

  @override
  State<AnimasiPage> createState() => _AnimasiPageState();
}

class _AnimasiPageState extends State<AnimasiPage>
    with SingleTickerProviderStateMixin {
  bool diperbesar = false;
  bool tampilIkon = true;
  double opacity = 1.0;
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
      appBar: AppBar(title: const Text('Demo Animasi Flutter')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: diperbesar ? 200 : 120,
                height: diperbesar ? 200 : 120,
                decoration: BoxDecoration(
                  color: diperbesar ? Colors.teal : Colors.indigo,
                  borderRadius: BorderRadius.circular(
                    diperbesar ? 100 : 20,
                  ),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 55,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() => diperbesar = !diperbesar);
                },
                child: const Text('Ubah Ukuran dan Bentuk'),
              ),
              const Divider(height: 35),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Icon(
                  tampilIkon ? Icons.favorite : Icons.thumb_up,
                  key: ValueKey(tampilIkon),
                  size: 65,
                  color: tampilIkon ? Colors.red : Colors.blue,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() => tampilIkon = !tampilIkon);
                },
                child: const Text('Ganti Ikon'),
              ),
              const Divider(height: 35),
              RotationTransition(
                turns: controller,
                child: const Icon(
                  Icons.settings,
                  size: 75,
                  color: Colors.deepOrange,
                ),
              ),
              const Text('Rotasi menggunakan AnimationController'),
              const Divider(height: 35),
              AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 500),
                child: const Text(
                  'Teks yang bisa menghilang',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() => opacity = opacity == 1.0 ? 0.0 : 1.0);
                },
                child: const Text('Tampilkan / Sembunyikan Teks'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
