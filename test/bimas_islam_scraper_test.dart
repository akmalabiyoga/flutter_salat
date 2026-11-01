import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_salat/services/bimas_islam_scraper.dart';

void main() {
  group('BimasIslamScraper with persistent http.Client', () {
    test('fetchCookiesAndProvinces parses JSON data correctly', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/sihat/provinsi');
        expect(request.headers['Accept'], 'application/json');

        final responseJson = {
          'status': 1,
          'message': 'Success',
          'data': [
            {'id': 'prov-1', 'name': 'JAWA BARAT'},
            {'id': 'prov-2', 'name': 'DKI JAKARTA'},
          ],
        };

        return http.Response(jsonEncode(responseJson), 200, headers: {
          'content-type': 'application/json',
        });
      });

      final scraper = BimasIslamScraper(client: mockClient);
      final provinces = await scraper.fetchCookiesAndProvinces();

      expect(provinces.length, 2);
      expect(provinces[0]['id'], 'prov-1');
      expect(provinces[0]['name'], 'JAWA BARAT');
      expect(provinces[0]['value'], 'prov-1');
      expect(provinces[0]['text'], 'JAWA BARAT');
    });

    test('fetchKabupatenKota passes province query parameter and parses correctly', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/sihat/kabko');
        expect(request.url.queryParameters['prov'], 'prov-1');

        final responseJson = {
          'status': 1,
          'message': 'Success',
          'data': [
            {'id': 'city-1', 'name': 'KAB. BOGOR'},
            {'id': 'city-2', 'name': 'KOTA BOGOR'},
          ],
        };

        return http.Response(jsonEncode(responseJson), 200);
      });

      final scraper = BimasIslamScraper(client: mockClient);
      final cities = await scraper.fetchKabupatenKota('prov-1');

      expect(cities.length, 2);
      expect(cities[0]['id'], 'city-1');
      expect(cities[0]['name'], 'KAB. BOGOR');
    });

    test('fetchJadwalSholat queries with padded month and returns data map', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/sihat/jadwal');
        expect(request.url.queryParameters['prov'], 'prov-1');
        expect(request.url.queryParameters['kabko'], 'city-1');
        expect(request.url.queryParameters['thn'], '2026');
        expect(request.url.queryParameters['bln'], '05'); // Padded month

        final responseJson = {
          'status': 1,
          'message': 'Success',
          'data': {
            '2026-05-01': {
              'imsak': '04:25',
              'subuh': '04:35',
              'dzuhur': '11:50',
            },
          },
        };

        return http.Response(jsonEncode(responseJson), 200);
      });

      final scraper = BimasIslamScraper(client: mockClient);
      final result = await scraper.fetchJadwalSholat('prov-1', 'city-1', '5', '2026');

      expect(result['status'], 1);
      final data = result['data'] as Map<String, dynamic>;
      expect(data.containsKey('2026-05-01'), isTrue);
    });

    test('throws Exception on HTTP error status', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final scraper = BimasIslamScraper(client: mockClient);
      expect(
        () => scraper.fetchCookiesAndProvinces(),
        throwsA(isA<Exception>()),
      );
    });
  });
}

