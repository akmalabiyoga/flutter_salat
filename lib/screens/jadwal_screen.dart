import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/jadwal_model.dart';
import '../providers/jadwal_provider.dart';
import '../widgets/today_prayer_header.dart';
import 'config_screen.dart';
import 'about_screen.dart';

class JadwalScreen extends ConsumerStatefulWidget {
  const JadwalScreen({super.key});

  @override
  ConsumerState<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends ConsumerState<JadwalScreen> {
  int _selectedNavIndex = 0;

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'imsak':
        return Icons.bedtime_outlined;
      case 'subuh':
        return Icons.wb_twilight_outlined;
      case 'terbit':
        return Icons.wb_sunny_outlined;
      case 'dhuha':
        return Icons.sunny;
      case 'dzuhur':
        return Icons.wb_sunny;
      case 'ashar':
        return Icons.wb_cloudy_outlined;
      case 'maghrib':
        return Icons.nights_stay_outlined;
      case 'isya':
        return Icons.dark_mode_outlined;
      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final jadwalAsyncValue = ref.watch(jadwalFutureProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    String displayCityName = "Select Location";
    if (jadwalAsyncValue.hasValue &&
        jadwalAsyncValue.value != null &&
        jadwalAsyncValue.value!.data.isNotEmpty) {
      displayCityName = jadwalAsyncValue.value!.data.first.kabupatenKotaName;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 640) {
          return _buildDesktopLayout(
            context,
            jadwalAsyncValue,
            selectedDate,
            displayCityName,
            isToday,
          );
        } else {
          return _buildMobileLayout(
            context,
            jadwalAsyncValue,
            selectedDate,
            displayCityName,
            isToday,
          );
        }
      },
    );
  }

  // --- MOBILE LAYOUT (< 640px) ---
  Widget _buildMobileLayout(
    BuildContext context,
    AsyncValue<JadwalResponse> jadwalAsyncValue,
    DateTime selectedDate,
    String displayCityName,
    bool isToday,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jadwal Sholat - $displayCityName',
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Pengaturan',
            onPressed: () {
              Navigator.pushNamed(context, '/config');
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Expanded(
                child: jadwalAsyncValue.when(
                  data: (response) {
                    if (response.data.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    final timingInfo = isToday
                        ? PrayerTimingInfo.calculate(response.data, DateTime.now())
                        : null;

                    return Column(
                      children: [
                        if (isToday)
                          TodayPrayerHeader(
                            prayers: response.data,
                            onTimingChanged: () {
                              if (mounted) setState(() {});
                            },
                          ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: response.data.length,
                            itemBuilder: (context, index) {
                              final item = response.data[index];
                              final timeObj = DateTime.tryParse(item.prayerTime);
                              final timeStr = timeObj != null
                                  ? DateFormat('HH:mm').format(timeObj)
                                  : item.prayerTime;

                              final isNearest = isToday && index == timingInfo?.nearestPrayerIndex;
                              final isLastOrNext = isToday &&
                                  (index == timingInfo?.lastPrayerIndex ||
                                      index == timingInfo?.nextPrayerIndex);

                              return Card(
                                elevation: isLastOrNext ? 0 : 1,
                                color: isLastOrNext
                                    ? Theme.of(context).colorScheme.primaryContainer
                                    : Theme.of(context).cardColor,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 2,
                                ),
                                child: ListTile(
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 0,
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        item.prayerName,
                                        style: TextStyle(
                                          fontWeight: isLastOrNext
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: isLastOrNext
                                              ? Theme.of(context).colorScheme.onPrimaryContainer
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
                                          ? Theme.of(context).colorScheme.onPrimaryContainer
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
                  error: (error, stack) => _buildErrorState(error),
                ),
              ),
              _buildBottomDateBar(context, selectedDate),
            ],
          ),
        ),
      ),
    );
  }

  // --- DESKTOP SHELL (>= 640px) ---
  Widget _buildDesktopLayout(
    BuildContext context,
    AsyncValue<JadwalResponse> jadwalAsyncValue,
    DateTime selectedDate,
    String displayCityName,
    bool isToday,
  ) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedNavIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedNavIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/app_icon.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.mosque,
                    size: 36,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month),
                label: Text('Jadwal'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Pengaturan'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.info_outline),
                selectedIcon: Icon(Icons.info),
                label: Text('Tentang'),
              ),
            ],
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: _buildDesktopBodyContent(
              context,
              jadwalAsyncValue,
              selectedDate,
              displayCityName,
              isToday,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopBodyContent(
    BuildContext context,
    AsyncValue<JadwalResponse> jadwalAsyncValue,
    DateTime selectedDate,
    String displayCityName,
    bool isToday,
  ) {
    if (_selectedNavIndex == 1) {
      return const ConfigScreen(isEmbedded: true);
    }
    if (_selectedNavIndex == 2) {
      return const AboutScreen(isEmbedded: true);
    }

    // Default: Tab Jadwal
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Header bar with city title and date switcher
        _buildDesktopHeader(context, selectedDate, displayCityName),
        const Divider(height: 1),
        Expanded(
          child: jadwalAsyncValue.when(
            data: (response) {
              if (response.data.isEmpty) {
                return _buildEmptyState(context);
              }

              final timingInfo = isToday
                  ? PrayerTimingInfo.calculate(response.data, DateTime.now())
                  : null;

              return Column(
                children: [
                  if (isToday)
                    TodayPrayerHeader(
                      prayers: response.data,
                      onTimingChanged: () {
                        if (mounted) setState(() {});
                      },
                      isDesktop: true,
                    ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 280,
                        mainAxisExtent: 110,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: response.data.length,
                      itemBuilder: (context, index) {
                        final item = response.data[index];
                        final timeObj = DateTime.tryParse(item.prayerTime);
                        final timeStr = timeObj != null
                            ? DateFormat('HH:mm').format(timeObj)
                            : item.prayerTime;

                        final isNearest = isToday && index == timingInfo?.nearestPrayerIndex;
                        final isLastOrNext = isToday &&
                            (index == timingInfo?.lastPrayerIndex ||
                                index == timingInfo?.nextPrayerIndex);

                        final theme = Theme.of(context);
                        final colorScheme = theme.colorScheme;

                        return Container(
                          decoration: BoxDecoration(
                            color: isLastOrNext
                                ? colorScheme.primaryContainer
                                : theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isLastOrNext
                                  ? colorScheme.primary.withValues(alpha: 0.5)
                                  : colorScheme.outlineVariant.withValues(alpha: 0.4),
                              width: isLastOrNext ? 1.5 : 1,
                            ),
                            boxShadow: isLastOrNext
                                ? [
                                    BoxShadow(
                                      color: colorScheme.primary.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _getPrayerIcon(item.prayerName),
                                    size: 20,
                                    color: isLastOrNext
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.prayerName,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isLastOrNext
                                            ? colorScheme.onPrimaryContainer
                                            : colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  if (isNearest)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.amber.shade600),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.star, color: Colors.amber, size: 14),
                                          SizedBox(width: 4),
                                          Text(
                                            'Terdekat',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              Text(
                                timeStr,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                  color: isLastOrNext
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(error),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopHeader(
    BuildContext context,
    DateTime selectedDate,
    String displayCityName,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Jadwal Sholat',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      displayCityName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'Hari Sebelumnya',
                  onPressed: () {
                    ref.read(selectedDateProvider.notifier).previousDay();
                  },
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    ref.read(selectedDateProvider.notifier).setToday();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      DateFormat('EEEE, d MMMM yyyy').format(selectedDate),
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'Hari Berikutnya',
                  onPressed: () {
                    ref.read(selectedDateProvider.notifier).nextDay();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No location selected',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please configure your city to see prayer times.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              if (MediaQuery.sizeOf(context).width >= 640) {
                setState(() => _selectedNavIndex = 1);
              } else {
                Navigator.pushNamed(context, '/config');
              }
            },
            icon: const Icon(Icons.settings),
            label: const Text('Configure Location'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Error loading schedule:\n$error',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildBottomDateBar(BuildContext context, DateTime selectedDate) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              ref.read(selectedDateProvider.notifier).previousDay();
            },
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                ref.read(selectedDateProvider.notifier).setToday();
              },
              child: Text(
                DateFormat('EEEE, d MMMM yyyy').format(selectedDate),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              ref.read(selectedDateProvider.notifier).nextDay();
            },
          ),
        ],
      ),
    );
  }
}
