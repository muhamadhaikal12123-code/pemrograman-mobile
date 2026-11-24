import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';

class FormKegiatanPage extends StatefulWidget {
  final Kegiatan? kegiatanEdit;
  const FormKegiatanPage({super.key, this.kegiatanEdit});
  @override
  State<FormKegiatanPage> createState() => _FormKegiatanPageState();
}

class _FormKegiatanPageState extends State<FormKegiatanPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulController;
  late final TextEditingController _nominalController;
  late DateTime _tanggalDipilih;
  late Tipe _tipe;
  late String _kategori;

  bool get _isEdit => widget.kegiatanEdit != null;

  @override
  void initState() {
    super.initState();
    final edit = widget.kegiatanEdit;
    _judulController = TextEditingController(text: edit?.judul ?? '');
    _nominalController = TextEditingController(
      text: (edit != null && edit.nominal > 0) ? edit.nominal.toString() : '',
    );
    _tanggalDipilih = edit != null ? DateTime.parse(edit.tanggal) : DateTime.now();
    _tipe = edit?.tipe ?? Tipe.tanpa;
    _kategori = (edit != null && daftarKategori.contains(edit.kategori)) ? edit.kategori : daftarKategori.first;
  }

  @override
  void dispose() {
    _judulController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggalDipilih,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (hasil != null) setState(() => _tanggalDipilih = hasil);
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    final nominal = _tipe == Tipe.tanpa ? 0 : int.parse(_nominalController.text.trim());
    final kategori = _tipe == Tipe.pengeluaran ? _kategori : '-';
    final data = Kegiatan(
      id: widget.kegiatanEdit?.id,
      judul: _judulController.text.trim(),
      tanggal: formatTanggalIso(_tanggalDipilih),
      selesai: widget.kegiatanEdit?.selesai ?? false,
      tipe: _tipe,
      nominal: nominal,
      kategori: kategori,
    );
    if (_isEdit) {
      await DbHelper.ubah(data);
    } else {
      await DbHelper.tambah(data);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final tanggalIso = formatTanggalIso(_tanggalDipilih);
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Ubah Kegiatan' : 'Tambah Kegiatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulController,
              decoration: const InputDecoration(labelText: 'Nama Kegiatan', border: OutlineInputBorder()),
              validator: (val) => (val == null || val.trim().isEmpty) ? 'Nama kegiatan wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(4),
              ),
              leading: const Icon(Icons.calendar_today),
              title: const Text('Tanggal Kegiatan'),
              subtitle: Text('${formatTanggalIndo(tanggalIso)} ($tanggalIso)'),
              onTap: _pilihTanggal,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Tipe>(
              value: _tipe,
              decoration: const InputDecoration(labelText: 'Jenis Keuangan', border: OutlineInputBorder()),
              items: Tipe.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label))).toList(),
              onChanged: (val) { if (val != null) setState(() => _tipe = val); },
            ),
            if (_tipe != Tipe.tanpa) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nominal (Rp)', prefixText: 'Rp ', border: OutlineInputBorder()),
                validator: (val) {
                  if (_tipe == Tipe.tanpa) return null;
                  if (val == null || val.trim().isEmpty) return 'Nominal wajib diisi';
                  final angka = int.tryParse(val.trim());
                  if (angka == null || angka <= 0) return 'Nominal harus berupa angka lebih dari 0';
                  return null;
                },
              ),
            ],
            if (_tipe == Tipe.pengeluaran) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: const InputDecoration(labelText: 'Kategori Pengeluaran', border: OutlineInputBorder()),
                items: daftarKategori.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
                onChanged: (val) { if (val != null) setState(() => _kategori = val); },
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _simpan,
              icon: const Icon(Icons.save),
              label: Text(_isEdit ? 'Simpan Perubahan' : 'Simpan Kegiatan'),
            ),
          ],
        ),
      ),
    );
  }
}
