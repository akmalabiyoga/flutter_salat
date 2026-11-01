import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatelessWidget {
  final bool isEmbedded;
  const AboutScreen({super.key, this.isEmbedded = false});

  static const String _repoUrl = 'https://github.com/akmalabiyoga/flutter_salat';
  static const String _issuesUrl = 'https://github.com/akmalabiyoga/flutter_salat/issues';

  void _openOrCopyUrl(BuildContext context, String url) async {
    bool launched = false;
    try {
      if (Platform.isLinux) {
        await Process.run('xdg-open', [url]);
        launched = true;
      } else if (Platform.isWindows) {
        await Process.run('start', [url], runInShell: true);
        launched = true;
      } else if (Platform.isMacOS) {
        await Process.run('open', [url]);
        launched = true;
      }
    } catch (_) {}

    await Clipboard.setData(ClipboardData(text: url));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            launched
                ? 'Membuka tautan di peramban...'
                : 'Tautan disalin ke papan klip:\n$url',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: isEmbedded
          ? null
          : AppBar(
              title: const Text('Tentang Aplikasi'),
            ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
          // Header: Icon, Name & Version
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/app_icon.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.access_time_filled,
                        size: 40,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Jadwal Salat',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Versi 1.0.1',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Aplikasi pengingat dan jadwal salat akurat, ringan, dan multiplatform untuk seluruh wilayah Indonesia.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section 1: Sumber Data
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified_outlined, color: colorScheme.primary, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Sumber Data Resmi',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Data jadwal salat diambil dari database resmi Bimas Islam Kementerian Agama Republik Indonesia (Kemenag RI) melalui layanan publik SIHAT (Sistem Informasi Hisab Rukyat).\n\nData disimpan secara lokal di perangkat Anda (offline-first), sehingga jadwal tetap dapat diakses tanpa koneksi internet setelah disinkronkan.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section 2: Disclaimer
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: colorScheme.primary, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Penafian (Disclaimer)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aplikasi ini merupakan proyek pribadi yang dikembangkan secara independen dan bersifat sumber terbuka (open source).\n\nAplikasi ini tidak berafiliasi, didukung, diasosiasikan, atau memiliki keterkaitan resmi dengan Kementerian Agama Republik Indonesia (Kemenag RI) maupun Direktorat Jenderal Bimbingan Masyarakat Islam.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section 3: Repositori GitHub
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.code_outlined, color: colorScheme.primary, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Repositori GitHub',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aplikasi ini merupakan proyek sumber terbuka (open source). Kode sumber lengkap tersedia di GitHub:',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _openOrCopyUrl(context, _repoUrl),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.link, size: 18, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _repoUrl,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.open_in_new, size: 16, color: colorScheme.outline),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section 4: Kontribusi & Bug Report
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite_outline, color: colorScheme.primary, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Kontribusi & Laporan Masalah',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Menemukan bug, waktu salat tidak cocok, atau memiliki saran fitur baru?\n\n'
                    '• Laporkan kendala dengan membuka Issue di halaman GitHub.\n'
                    '• Ingin berkontribusi kode? Silakan buat fork repositori dan kirimkan Pull Request (PR).',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openOrCopyUrl(context, _issuesUrl),
                      icon: const Icon(Icons.bug_report_outlined, size: 18),
                      label: const Text('Buka GitHub Issues'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Footer
          Center(
            child: Text(
              'Dibuat secara independen menggunakan Flutter • Open Source',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.textTheme.labelSmall?.color?.withValues(alpha: 0.6),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  ),
);
  }
}

