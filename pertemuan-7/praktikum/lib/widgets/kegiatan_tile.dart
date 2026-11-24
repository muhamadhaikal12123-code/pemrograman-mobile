import 'package:flutter/material.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';

class KegiatanTile extends StatelessWidget {
  final Kegiatan kegiatan;
  final ValueChanged<bool?> onToggleSelesai;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const KegiatanTile({
    super.key,
    required this.kegiatan,
    required this.onToggleSelesai,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colors = tema.colorScheme;
    String nominalText = 'Tanpa uang';
    Color nominalColor = colors.onSurfaceVariant;

    if (kegiatan.tipe == Tipe.pemasukan) {
      nominalText = '+${formatRupiah(kegiatan.nominal)}';
      nominalColor = Colors.green;
    } else if (kegiatan.tipe == Tipe.pengeluaran) {
      nominalText = '-${formatRupiah(kegiatan.nominal)} (${kegiatan.kategori})';
      nominalColor = colors.error;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(value: kegiatan.selesai, onChanged: onToggleSelesai),
        title: Text(
          kegiatan.judul,
          style: tema.textTheme.titleMedium?.copyWith(
            decoration: kegiatan.selesai ? TextDecoration.lineThrough : null,
            color: kegiatan.selesai ? colors.onSurfaceVariant : null,
          ),
        ),
        subtitle: Text(
          nominalText,
          style: tema.textTheme.bodyMedium?.copyWith(color: nominalColor, fontWeight: FontWeight.w600),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit_outlined), tooltip: 'Ubah', onPressed: onEdit),
            IconButton(icon: Icon(Icons.delete_outline, color: colors.error), tooltip: 'Hapus', onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
