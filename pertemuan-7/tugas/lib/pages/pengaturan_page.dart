import 'package:flutter/material.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colors = tema.colorScheme;
    return ListenableBuilder(
      listenable: Listenable.merge([
        PengaturanState.themeMode,
        PengaturanState.seedColor,
        PengaturanState.targetHarian,
      ]),
      builder: (context, _) {
        final target = PengaturanState.targetHarian.value;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Target Tabungan Harian', style: tema.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(formatRupiah(target),
                style: tema.textTheme.headlineSmall?.copyWith(color: colors.primary, fontWeight: FontWeight.bold)),
            Slider(
              value: target.toDouble().clamp(5000, 100000),
              min: 5000,
              max: 100000,
              divisions: 19,
              label: formatRupiah(target),
              onChanged: (val) => PengaturanState.setTargetHarian(val.round()),
            ),
            const Divider(height: 32),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Mode Gelap'),
              subtitle: const Text('Tema aplikasi tersimpan otomatis'),
              value: PengaturanState.themeMode.value == ThemeMode.dark,
              onChanged: (v) => PengaturanState.setDarkMode(v),
            ),
            const SizedBox(height: 16),
            Text('Warna Tema', style: tema.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                for (final c in pilihanWarnaTema)
                  GestureDetector(
                    onTap: () => PengaturanState.setSeedColor(c),
                    child: CircleAvatar(
                      backgroundColor: c,
                      child: PengaturanState.seedColor.value.toARGB32() == c.toARGB32()
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
