import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/jadwal_provider.dart';
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
  Widget build(BuildContext context) {
    final provincesAsync = ref.watch(provincesProvider);
    final cityIdAsync = ref.watch(cityIdProvider);
    final currentCityId = cityIdAsync.value ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
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
                    error: (e, s) => Text('Error: \$e'),
                  );
                },
              ),
            ],

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
            Text("Currently Selected City ID: ${currentCityId.isEmpty ? 'None' : currentCityId}"),
            const Spacer(),
            TextButton(
              onPressed: () async {
                await NotificationService().showNotification(
                  id: 999,
                  title: 'Test Notification',
                  body: 'This is a test notification from Flutter Salat.',
                );
              },
              child: const Text('Test Notification Alert'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                await ref.read(databaseProvider).clearDatabase();
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
