import 'package:flutter/material.dart';

void main() {
  runApp(const KartuPerkenalan());
}

class KartuPerkenalan extends StatelessWidget {
  const KartuPerkenalan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartu Perkenalan',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kartu Perkenalan'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.person,
                size: 100,
                color: Colors.blue,
              ),
              SizedBox(height: 20),
              Text(
                'Muhamad Haikal Umardi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text('NIM: 20240801169'),
              Text('Prodi: Teknik Informatika'),
              Text('Hobi: Sepak Bola'),
            ],
          ),
        ),
      ),
    );
  }
}
