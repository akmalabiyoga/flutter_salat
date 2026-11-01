import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_salat/models/jadwal_model.dart';
import 'package:flutter_salat/widgets/today_prayer_header.dart';

void main() {
  group('PrayerTimingInfo.calculate', () {
    final mockPrayers = [
      PrayerTime(
        prayerDate: '2026-11-01',
        prayerTime: '2026-11-01 04:30:00',
        prayerName: 'Subuh',
        kabupatenKotaName: 'Kab. Bogor',
        provinsiName: 'Jawa Barat',
      ),
      PrayerTime(
        prayerDate: '2026-11-01',
        prayerTime: '2026-11-01 05:45:00',
        prayerName: 'Terbit',
        kabupatenKotaName: 'Kab. Bogor',
        provinsiName: 'Jawa Barat',
      ),
      PrayerTime(
        prayerDate: '2026-11-01',
        prayerTime: '2026-11-01 11:50:00',
        prayerName: 'Dzuhur',
        kabupatenKotaName: 'Kab. Bogor',
        provinsiName: 'Jawa Barat',
      ),
      PrayerTime(
        prayerDate: '2026-11-01',
        prayerTime: '2026-11-01 15:05:00',
        prayerName: 'Ashar',
        kabupatenKotaName: 'Kab. Bogor',
        provinsiName: 'Jawa Barat',
      ),
      PrayerTime(
        prayerDate: '2026-11-01',
        prayerTime: '2026-11-01 17:55:00',
        prayerName: 'Maghrib',
        kabupatenKotaName: 'Kab. Bogor',
        provinsiName: 'Jawa Barat',
      ),
      PrayerTime(
        prayerDate: '2026-11-01',
        prayerTime: '2026-11-01 19:05:00',
        prayerName: 'Isya',
        kabupatenKotaName: 'Kab. Bogor',
        provinsiName: 'Jawa Barat',
      ),
    ];

    test('correctly identifies next prayer when before first prayer', () {
      final now = DateTime.parse('2026-11-01 04:00:00');
      final timing = PrayerTimingInfo.calculate(mockPrayers, now);

      expect(timing.lastPrayerIndex, isNull);
      expect(timing.nextPrayerIndex, 0); // Subuh
      expect(timing.nearestPrayerIndex, 0);
      expect(timing.nearestIsNext, isTrue);
      expect(timing.nearestDuration, const Duration(minutes: 30));
    });

    test('correctly identifies nearest and adjacent prayer between two times', () {
      // 04:35 -> closer to Subuh (04:30) than Terbit (05:45)
      final now = DateTime.parse('2026-11-01 04:35:00');
      final timing = PrayerTimingInfo.calculate(mockPrayers, now);

      expect(timing.lastPrayerIndex, 0); // Subuh
      expect(timing.nextPrayerIndex, 1); // Terbit
      expect(timing.nearestPrayerIndex, 0); // Closer to Subuh
      expect(timing.nearestIsNext, isFalse);
      expect(timing.nearestDuration, const Duration(minutes: 5));
      expect(timing.unhighlightedIndex, 1); // Next prayer Terbit
      expect(timing.unhighlightedIsNext, isTrue);
    });

    test('correctly shifts nearest prayer past the midpoint', () {
      // 05:40 -> closer to Terbit (05:45) than Subuh (04:30)
      final now = DateTime.parse('2026-11-01 05:40:00');
      final timing = PrayerTimingInfo.calculate(mockPrayers, now);

      expect(timing.lastPrayerIndex, 0); // Subuh
      expect(timing.nextPrayerIndex, 1); // Terbit
      expect(timing.nearestPrayerIndex, 1); // Closer to Terbit
      expect(timing.nearestIsNext, isTrue);
      expect(timing.nearestDuration, const Duration(minutes: 5));
      expect(timing.unhighlightedIndex, 0); // Last prayer Subuh
      expect(timing.unhighlightedIsNext, isFalse);
    });

    test('correctly handles time after the last prayer', () {
      final now = DateTime.parse('2026-11-01 21:00:00');
      final timing = PrayerTimingInfo.calculate(mockPrayers, now);

      expect(timing.lastPrayerIndex, 5); // Isya
      expect(timing.nextPrayerIndex, isNull);
      expect(timing.nearestPrayerIndex, 5);
      expect(timing.nearestIsNext, isFalse);
    });

    test('handles empty prayer list gracefully', () {
      final now = DateTime.parse('2026-11-01 12:00:00');
      final timing = PrayerTimingInfo.calculate([], now);

      expect(timing.nearestPrayerIndex, isNull);
      expect(timing.lastPrayerIndex, isNull);
      expect(timing.nextPrayerIndex, isNull);
    });
  });
}

