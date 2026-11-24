import 'package:flutter/material.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';

class RingkasanCard extends StatelessWidget {
  final Ringkasan ringkasan;
  final int targetHarian;
  const RingkasanCard({super.key, required this.ringkasan, required this.targetHarian});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colors = tema.colorScheme;
    final tabungan = ringkasan.tabungan;
    final negatif = tabungan < 0;
    final tercapai = targetHarian > 0 && tabungan >= targetHarian;
    final rasio = targetHarian <= 0 ? 0.0 : (tabungan / targetHarian).clamp(0.0, 1.0);

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ringkasan Keuangan', style: tema.textTheme.titleMedium),
                Chip(label: Text('Selesai ${ringkasan.selesai}/${ringkasan.jumlahKegiatan}')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _Info('Pemasukan', formatRupiah(ringkasan.pemasukan), Colors.green)),
                Expanded(child: _Info('Pengeluaran', formatRupiah(ringkasan.pengeluaran), colors.error)),
                Expanded(child: _Info('Tabungan', formatRupiah(tabungan), negatif ? colors.error : colors.primary)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Target Harian: ${formatRupiah(targetHarian)}', style: tema.textTheme.bodySmall),
                Text('${(rasio * 100).toStringAsFixed(0)}%', style: tema.textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 6),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: rasio),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: colors.surfaceContainerHighest,
                  color: negatif ? colors.error : (tercapai ? Colors.green : colors.primary),
                ),
              ),
            ),
            if (negatif) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: colors.errorContainer, borderRadius: BorderRadius.circular(8)),
                child: Text('Peringatan: Tabungan hari ini negatif! Kurangi pengeluaran.',
                    style: tema.textTheme.bodySmall?.copyWith(color: colors.onErrorContainer)),
              ),
            ] else if (tercapai) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: colors.primaryContainer, borderRadius: BorderRadius.circular(8)),
                child: Text('Apresiasi: Target menabung harian tercapai!',
                    style: tema.textTheme.bodySmall?.copyWith(color: colors.onPrimaryContainer)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String label, nilai;
  final Color warna;
  const _Info(this.label, this.nilai, this.warna);

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: tema.textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(nilai, style: tema.textTheme.titleSmall?.copyWith(color: warna, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
