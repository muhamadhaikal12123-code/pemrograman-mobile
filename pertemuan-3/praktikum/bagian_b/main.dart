
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum B',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();

  String? _kategori;
  bool _setuju = false;

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      if (_kategori == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan pilih kategori terlebih dahulu'),
          ),
        );
        return;
      }

      if (!_setuju) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan centang persetujuan terlebih dahulu'),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data ${_namaController.text} berhasil disimpan!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum B - Form Validation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
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
              const SizedBox(height: 24),

              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }

                  if (value.trim().length < 3) {
                    return 'Nama minimal 3 karakter';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _kategori,
                decoration: const InputDecoration(
                  labelText: 'Pilih Kategori',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Mahasiswa',
                    child: Text('Mahasiswa'),
                  ),
                  DropdownMenuItem(
                    value: 'Dosen',
                    child: Text('Dosen'),
                  ),
                  DropdownMenuItem(
                    value: 'Umum',
                    child: Text('Umum'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _kategori = value;
                  });
                },
              ),
              const SizedBox(height: 8),

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Saya menyetujui data yang dimasukkan'),
                value: _setuju,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    _setuju = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
