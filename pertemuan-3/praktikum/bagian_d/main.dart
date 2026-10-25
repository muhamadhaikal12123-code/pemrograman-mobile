
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum D',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _tasks = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tambahTugas() {
    final judul = _controller.text.trim();

    if (judul.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul tugas minimal 3 karakter!'),
        ),
      );
      return;
    }

    setState(() {
      _tasks.add({
        'judul': judul,
        'selesai': false,
      });
      _controller.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tugas berhasil ditambahkan'),
      ),
    );
  }

  void _hapusTugas(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _hapusTugasSelesai() {
    setState(() {
      _tasks.removeWhere((task) => task['selesai'] == true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final jumlahSelesai =
        _tasks.where((task) => task['selesai'] == true).length;
    final jumlahBelumSelesai = _tasks.length - jumlahSelesai;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum D - To-Do List'),
        actions: [
          IconButton(
            tooltip: 'Hapus tugas selesai',
            onPressed: _hapusTugasSelesai,
            icon: const Icon(Icons.delete_sweep),
          ),
        ],
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
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Masukkan tugas',
                hintText: 'Contoh: Belajar Flutter',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
              onSubmitted: (_) => _tambahTugas(),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _tambahTugas,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Tugas'),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Total Tugas'),
                        Text(
                          '${_tasks.length}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Belum Selesai'),
                        Text(
                          '$jumlahBelumSelesai',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Selesai'),
                        Text(
                          '$jumlahSelesai',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.checklist,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text('Belum ada tugas'),
                          Text('Tambahkan tugas pertama kamu!'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];

                        return Card(
                          child: CheckboxListTile(
                            value: task['selesai'] as bool,
                            onChanged: (value) {
                              setState(() {
                                task['selesai'] = value ?? false;
                              });
                            },
                            title: Text(
                              task['judul'] as String,
                              style: TextStyle(
                                decoration: task['selesai'] == true
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            secondary: IconButton(
                              onPressed: () => _hapusTugas(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
