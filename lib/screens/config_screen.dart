import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/jadwal_provider.dart';
import '../providers/theme_provider.dart';
import '../services/database/database_provider.dart';
import '../services/notification_service.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  String? selectedProvinceId;
  String? selectedCityId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cityId = ref.read(cityIdProvider).value ?? '';
      if (cityId.isNotEmpty && mounted) {
        final db = ref.read(databaseProvider);
        final city = await (db.select(db.cities)
              ..where((t) => t.id.equals(cityId)))
            .getSingleOrNull();
        if (city != null && mounted) {
          setState(() {
            selectedProvinceId = city.provinceId;
            selectedCityId = city.id;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provincesAsync = ref.watch(provincesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Tentang Aplikasi',
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Province:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            provincesAsync.when(
              data: (provinces) => DropdownButton<String>(
                isExpanded: true,
                value: selectedProvinceId,
                hint: const Text('Select Province'),
                items: provinces.map((p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(p.name),
                )).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedProvinceId = val;
                    selectedCityId = null; // Reset city when province changes
                  });
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, s) => Text('Error: $e'),
            ),
            const SizedBox(height: 24),

            if (selectedProvinceId != null) ...[
              const Text(
                'Select City:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, child) {
                  final citiesAsync = ref.watch(citiesProvider(selectedProvinceId!));
                  return citiesAsync.when(
                    data: (cities) => DropdownButton<String>(
                      isExpanded: true,
                      value: selectedCityId,
                      hint: const Text('Select City'),
                      items: cities.map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name),
                      )).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedCityId = val;
                        });
                      },
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, s) => Text('Error: $e'),
                  );
                },
              ),
            ],

            const SizedBox(height: 24),
            const Text(
              'Theme:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Consumer(
              builder: (context, ref, child) {
                final themeMode = ref.watch(themeProvider);
                return SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
                      icon: Icon(Icons.brightness_auto),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (Set<ThemeMode> newSelection) {
                    ref.read(themeProvider.notifier).setThemeMode(newSelection.first);
                  },
                );
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: selectedCityId == null ? null : () async {
                  await ref.read(cityIdProvider.notifier).setCity(selectedCityId!);
                  // Trigger pre-fetch in background
                  ref.invalidate(jadwalFutureProvider);
                  // We don't await it here to avoid blocking UI, 
                  // but it starts the work in the background.
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Configuration saved! Fetching schedules...')),
                    );
                    Navigator.pop(context); // Go back to main screen
                  }
                },
                child: const Text('Save Configuration'),
              ),
            ),
            const SizedBox(height: 24),
            Consumer(
              builder: (context, ref, child) {
                final locationAsync = ref.watch(selectedLocationProvider);
                final theme = Theme.of(context);
                final colorScheme = theme.colorScheme;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: colorScheme.primary, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lokasi Terpilih Saat Ini:',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            locationAsync.when(
                              data: (loc) => Text(
                                loc != null
                                    ? '${loc.cityName}, ${loc.provinceName}'
                                    : 'Belum ada lokasi yang dipilih',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              loading: () => Text(
                                'Memuat info lokasi...',
                                style: theme.textTheme.bodyMedium,
                              ),
                              error: (_, __) => Text(
                                'Tidak dapat memuat info lokasi',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/about'),
                icon: const Icon(Icons.info_outline),
                label: const Text('Tentang Aplikasi'),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () async {
                await NotificationService().showNotification(
                  id: 999,
                  title: 'Waktu Dzuhur Tiba',
                  body: 'Wilayah Kab. Bogor sudah masuk waktu Dzuhur',
                );
              },
              child: const Text('Test Notification Alert'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                await ref.read(databaseProvider).clearDatabase();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Database cleared. Please restart the app or re-select location.')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Reset All Data (Sync Fix)'),
            ),
          ],
        ),
      ),
    );
  }
}
