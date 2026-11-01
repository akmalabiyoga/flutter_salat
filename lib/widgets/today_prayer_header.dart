import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/jadwal_model.dart';

/// Calculation result representing which prayers are nearest, last, and next.
class PrayerTimingInfo {
  final int? lastPrayerIndex;
  final int? nextPrayerIndex;
  final int? nearestPrayerIndex;
  final Duration? nearestDuration;
  final bool nearestIsNext;
  final int? unhighlightedIndex;
  final Duration? unhighlightedDuration;
  final bool unhighlightedIsNext;

  const PrayerTimingInfo({
    this.lastPrayerIndex,
    this.nextPrayerIndex,
    this.nearestPrayerIndex,
    this.nearestDuration,
    this.nearestIsNext = false,
    this.unhighlightedIndex,
    this.unhighlightedDuration,
    this.unhighlightedIsNext = false,
  });

  /// Calculates prayer timings relative to [now].
  static PrayerTimingInfo calculate(List<PrayerTime> data, DateTime now) {
    int? lastIndex;
    int? nextIndex;
    Duration? minLastDuration;
    Duration? minNextDuration;

    for (int i = 0; i < data.length; i++) {
      final timeObj = DateTime.tryParse(data[i].prayerTime);
      if (timeObj != null) {
        if (timeObj.isBefore(now)) {
          final diff = now.difference(timeObj);
          if (minLastDuration == null || diff < minLastDuration) {
            minLastDuration = diff;
            lastIndex = i;
          }
        } else if (timeObj.isAfter(now)) {
          final diff = timeObj.difference(now);
          if (minNextDuration == null || diff < minNextDuration) {
            minNextDuration = diff;
            nextIndex = i;
          }
        }
      }
    }

    int? nearestIndex;
    if (minLastDuration != null && minNextDuration != null) {
      nearestIndex = minLastDuration < minNextDuration ? lastIndex : nextIndex;
    } else if (minLastDuration != null) {
      nearestIndex = lastIndex;
    } else if (minNextDuration != null) {
      nearestIndex = nextIndex;
    }

    if (nearestIndex == null) {
      return const PrayerTimingInfo();
    }

    final nearestIsNext = nearestIndex == nextIndex;
    final nearestDuration = nearestIsNext ? minNextDuration! : minLastDuration!;

    int? unhighlightedIndex;
    Duration? unhighlightedDuration;
    bool unhighlightedIsNext = false;

    if (nearestIndex == lastIndex) {
      unhighlightedIndex = nextIndex;
      unhighlightedDuration = minNextDuration;
      unhighlightedIsNext = true;
    } else {
      unhighlightedIndex = lastIndex;
      unhighlightedDuration = minLastDuration;
      unhighlightedIsNext = false;
    }

    return PrayerTimingInfo(
      lastPrayerIndex: lastIndex,
      nextPrayerIndex: nextIndex,
      nearestPrayerIndex: nearestIndex,
      nearestDuration: nearestDuration,
      nearestIsNext: nearestIsNext,
      unhighlightedIndex: unhighlightedIndex,
      unhighlightedDuration: unhighlightedDuration,
      unhighlightedIsNext: unhighlightedIsNext,
    );
  }
}

/// An isolated widget that handles countdown ticking every second.
/// By isolating the periodic timer inside this widget, the parent
/// [JadwalScreen] and its entire widget tree (Scaffold, AppBar, ListView, etc.)
/// do not need to rebuild 60 times a minute.
class TodayPrayerHeader extends StatefulWidget {
  final List<PrayerTime> prayers;
  final VoidCallback? onTimingChanged;
  final bool isDesktop;

  const TodayPrayerHeader({
    super.key,
    required this.prayers,
    this.onTimingChanged,
    this.isDesktop = false,
  });

  @override
  State<TodayPrayerHeader> createState() => _TodayPrayerHeaderState();
}

class _TodayPrayerHeaderState extends State<TodayPrayerHeader> {
  Timer? _timer;
  late PrayerTimingInfo _timingInfo;

  @override
  void initState() {
    super.initState();
    _timingInfo = PrayerTimingInfo.calculate(widget.prayers, DateTime.now());
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant TodayPrayerHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.prayers != oldWidget.prayers) {
      _timingInfo = PrayerTimingInfo.calculate(widget.prayers, DateTime.now());
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newTiming = PrayerTimingInfo.calculate(widget.prayers, DateTime.now());
      final prayerIndexChanged =
          newTiming.nearestPrayerIndex != _timingInfo.nearestPrayerIndex ||
          newTiming.lastPrayerIndex != _timingInfo.lastPrayerIndex ||
          newTiming.nextPrayerIndex != _timingInfo.nextPrayerIndex;

      if (mounted) {
        setState(() {
          _timingInfo = newTiming;
        });
      }

      if (prayerIndexChanged) {
        widget.onTimingChanged?.call();
      }
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
    final nearestIndex = _timingInfo.nearestPrayerIndex;
    if (nearestIndex == null || nearestIndex >= widget.prayers.length) {
      return const SizedBox.shrink();
    }

    final nearestPrayer = widget.prayers[nearestIndex];
    final nearestDuration = _timingInfo.nearestDuration ?? Duration.zero;
    final nearestIsNext = _timingInfo.nearestIsNext;

    final unhighlightedIndex = _timingInfo.unhighlightedIndex;
    final unhighlightedDuration = _timingInfo.unhighlightedDuration;
    final unhighlightedIsNext = _timingInfo.unhighlightedIsNext;

    if (widget.isDesktop) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return Container(
        margin: const EdgeInsets.fromLTRB(24, 8, 24, 8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.access_time_filled,
                size: 32,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${nearestPrayer.prayerName} ${DateFormat('HH:mm').format(DateTime.parse(nearestPrayer.prayerTime))}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    nearestIsNext
                        ? 'In ${_formatDuration(nearestDuration)}'
                        : '${_formatDuration(nearestDuration)} ago',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            if (unhighlightedIndex != null && unhighlightedIndex < widget.prayers.length)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.prayers[unhighlightedIndex].prayerName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${DateFormat('HH:mm').format(DateTime.parse(widget.prayers[unhighlightedIndex].prayerTime))} • ${unhighlightedIsNext ? 'In' : ''} ${_formatDuration(unhighlightedDuration ?? Duration.zero)}${unhighlightedIsNext ? '' : ' ago'}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top Container: Nearest Prayer
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ),
          color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
          child: Column(
            children: [
              Text(
                '${nearestPrayer.prayerName} ${DateFormat('HH:mm').format(DateTime.parse(nearestPrayer.prayerTime))}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
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
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),

        // Below Container: Unhighlighted adjacent
        if (unhighlightedIndex != null && unhighlightedIndex < widget.prayers.length)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3),
            child: Center(
              child: Text(
                '${widget.prayers[unhighlightedIndex].prayerName} ${DateFormat('HH:mm').format(DateTime.parse(widget.prayers[unhighlightedIndex].prayerTime))}  •  ${unhighlightedIsNext ? 'In' : ''} ${_formatDuration(unhighlightedDuration ?? Duration.zero)}${unhighlightedIsNext ? '' : ' ago'}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

