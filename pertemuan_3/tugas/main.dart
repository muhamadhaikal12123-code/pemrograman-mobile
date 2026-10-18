
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShoppingProvider(),
      child: const MyApp(),
    ),
  );
}

class ShoppingItem {
  String nama;
  int jumlah;
  String kategori;
  bool dibeli;

  ShoppingItem({
    required this.nama,
    required this.jumlah,
    required this.kategori,
    this.dibeli = false,
  });
}

class ShoppingProvider extends ChangeNotifier {
  final List<ShoppingItem> _items = [];

  List<ShoppingItem> get items => _items;

  int get belumDibeli =>
      _items.where((item) => !item.dibeli).length;

  void tambahItem(
    String nama,
    int jumlah,
    String kategori,
  ) {
    _items.add(
      ShoppingItem(
        nama: nama,
        jumlah: jumlah,
        kategori: kategori,
      ),
    );
    notifyListeners();
  }

  void ubahStatus(ShoppingItem item, bool dibeli) {
    item.dibeli = dibeli;
    notifyListeners();
  }

  void hapusItem(ShoppingItem item) {
    _items.remove(item);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping List',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const ShoppingPage(),
    );
  }
}

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();

  String _kategori = 'Makanan';

  final List<String> _kategoriList = [
    'Makanan',
    'Minuman',
    'Kebutuhan Rumah',
    'Elektronik',
    'Lainnya',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  void _tambahBarang() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nama = _namaController.text.trim();
    final jumlah = int.parse(_jumlahController.text);

    context.read<ShoppingProvider>().tambahItem(
          nama,
          jumlah,
          _kategori,
        );

    _namaController.clear();
    _jumlahController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Barang berhasil ditambahkan!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shopping = context.watch<ShoppingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Belum dibeli: ${shopping.belumDibeli}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Barang',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_bag),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama barang wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _jumlahController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Barang',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    validator: (value) {
                      final jumlah = int.tryParse(value ?? '');

                      if (jumlah == null || jumlah <= 0) {
                        return 'Jumlah harus lebih dari 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    initialValue: _kategori,
                    decoration: const InputDecoration(
                      labelText: 'Kategori Barang',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: _kategoriList.map((kategori) {
                      return DropdownMenuItem(
                        value: kategori,
                        child: Text(kategori),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _kategori = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _tambahBarang,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Tambah Barang'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Daftar Belanja',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: shopping.items.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text('Belum ada barang belanja'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: shopping.items.length,
                      itemBuilder: (context, index) {
                        final item = shopping.items[index];

                        return Card(
                          child: CheckboxListTile(
                            value: item.dibeli,
                            onChanged: (value) {
                              context.read<ShoppingProvider>().ubahStatus(
                                    item,
                                    value ?? false,
                                  );
                            },
                            title: Text(
                              item.nama,
                              style: TextStyle(
                                decoration: item.dibeli
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text(
                              'Jumlah: ${item.jumlah} • ${item.kategori}',
                            ),
                            secondary: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                context
                                    .read<ShoppingProvider>()
                                    .hapusItem(item);
                              },
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
