import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/jadwal_provider.dart';

class JadwalScreen extends ConsumerStatefulWidget {
  const JadwalScreen({super.key});

  @override
  ConsumerState<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends ConsumerState<JadwalScreen> {
  Timer? _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Update the current time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return "${hours}h ${minutes}m";
    } else {
      return "${minutes}m";
    }
  }

  @override
  Widget build(BuildContext context) {
    final jadwalAsyncValue = ref.watch(jadwalFutureProvider);
    final selectedCity = ref.watch(cityIdProvider);

    // Activate notification scheduler
    ref.watch(notificationSchedulerProvider);

    // Use the proper city name from the API response if available, else fallback to slug
    String displayCityName = selectedCity.toUpperCase();
    if (jadwalAsyncValue.hasValue &&
        jadwalAsyncValue.value != null &&
        jadwalAsyncValue.value!.data.isNotEmpty) {
      displayCityName = jadwalAsyncValue.value!.data.first.kabupatenKotaName;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jadwal Sholat - $displayCityName',
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(jadwalFutureProvider);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/config');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(jadwalFutureProvider.future);
        },
        child: Column(
          children: [
            Expanded(
              child: jadwalAsyncValue.when(
              data: (response) {
                if (response.data.isEmpty) {
                  return const Center(
                    child: Text('No schedule available for today.'),
                  );
                }

                // Logic for finding last, next, and nearest
                int? lastPrayerIndex;
                int? nextPrayerIndex;
                Duration? minLastDuration;
                Duration? minNextDuration;

                for (int i = 0; i < response.data.length; i++) {
                  final timeObj = DateTime.tryParse(
                    response.data[i].prayerTime,
                  );
                  if (timeObj != null) {
                    if (timeObj.isBefore(_currentTime)) {
                      final diff = _currentTime.difference(timeObj);
                      if (minLastDuration == null || diff < minLastDuration) {
                        minLastDuration = diff;
                        lastPrayerIndex = i;
                      }
                    } else if (timeObj.isAfter(_currentTime)) {
                      final diff = timeObj.difference(_currentTime);
                      if (minNextDuration == null || diff < minNextDuration) {
                        minNextDuration = diff;
                        nextPrayerIndex = i;
                      }
                    }
                  }
                }

                int? nearestPrayerIndex;
                if (minLastDuration != null && minNextDuration != null) {
                  nearestPrayerIndex = minLastDuration < minNextDuration
                      ? lastPrayerIndex
                      : nextPrayerIndex;
                } else if (minLastDuration != null) {
                  nearestPrayerIndex = lastPrayerIndex;
                } else if (minNextDuration != null) {
                  nearestPrayerIndex = nextPrayerIndex;
                }

                if (nearestPrayerIndex == null) {
                   return const Center(child: Text('Could not determine nearest prayer time. Check your internet or city settings.'));
                }

                bool nearestIsNext = nearestPrayerIndex == nextPrayerIndex;
                Duration nearestDuration = nearestIsNext
                    ? minNextDuration!
                    : minLastDuration!;

                int? unhighlightedIndex;
                Duration? unhighlightedDuration;
                bool unhighlightedIsNext = false;

                if (nearestPrayerIndex == lastPrayerIndex) {
                  unhighlightedIndex = nextPrayerIndex;
                  unhighlightedDuration = minNextDuration;
                  unhighlightedIsNext = true;
                } else {
                  unhighlightedIndex = lastPrayerIndex;
                  unhighlightedDuration = minLastDuration;
                  unhighlightedIsNext = false;
                }

                return Column(
                  children: [
                    // Top Container: Nearest Prayer
                    Container(
                      width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 16,
                        ),
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                        child: Column(
                          children: [
                            Text(
                              '${response.data[nearestPrayerIndex].prayerName} ${DateFormat('HH:mm').format(DateTime.parse(response.data[nearestPrayerIndex].prayerTime))}',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              nearestIsNext
                                  ? 'In ${_formatDuration(nearestDuration)}'
                                  : '${_formatDuration(nearestDuration)} ago',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Below Container: Unhighlighted adjacent
                    if (unhighlightedIndex != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.05),
                        child: Center(
                          child: Text(
                            '${response.data[unhighlightedIndex].prayerName} ${DateFormat('HH:mm').format(DateTime.parse(response.data[unhighlightedIndex].prayerTime))}  •  ${unhighlightedIsNext ? 'In' : ''} ${_formatDuration(unhighlightedDuration!)}${unhighlightedIsNext ? '' : ' ago'}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 8),

                    // List of Prayers
                    Expanded(
                      child: ListView.builder(
                        itemCount: response.data.length,
                        itemBuilder: (context, index) {
                          final item = response.data[index];
                          final timeObj = DateTime.tryParse(item.prayerTime);
                          final timeStr = timeObj != null
                              ? DateFormat('HH:mm').format(timeObj)
                              : item.prayerTime;

                          final isNearest = index == nearestPrayerIndex;
                          final isLastOrNext =
                              index == lastPrayerIndex ||
                              index == nextPrayerIndex;

                          return Card(
                            elevation: isLastOrNext ? 0 : 1,
                            color: isLastOrNext
                                ? Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.2)
                                : Theme.of(context).cardColor,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 2,
                            ),
                            child: ListTile(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                              title: Row(
                                children: [
                                  Text(
                                    item.prayerName,
                                    style: TextStyle(
                                      fontWeight: isLastOrNext
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isLastOrNext
                                          ? Colors.teal.shade900
                                          : null,
                                    ),
                                  ),
                                  if (isNearest) ...[
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                  ],
                                ],
                              ),
                              trailing: Text(
                                timeStr,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isLastOrNext
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isLastOrNext
                                      ? Colors.teal.shade900
                                      : null,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error loading schedule:\n$error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
