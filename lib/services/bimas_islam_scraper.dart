import 'dart:convert';
import 'package:http/http.dart' as http;

class BimasIslamScraper {
  final http.Client _client;

  BimasIslamScraper({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://bimasislam.kemenag.go.id';
  static const String _provinsiUrl = '$_baseUrl/api/sihat/provinsi';
  static const String _kabKotaUrl = '$_baseUrl/api/sihat/kabko';
  static const String _jadwalUrl = '$_baseUrl/api/sihat/jadwal';

  static const Map<String, String> _defaultHeaders = {
    'Accept': 'application/json',
    'Referer': 'https://bimasislam.kemenag.go.id/jadwal-sholat',
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36',
  };

  /// Fetch the list of provinces from SIHAT API.
  Future<List<Map<String, String>>> fetchCookiesAndProvinces() async {
    final response = await _client
        .get(
          Uri.parse(_provinsiUrl),
          headers: _defaultHeaders,
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch provinces: HTTP ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    final List<dynamic> data = decoded['data'] as List<dynamic>? ?? [];

    return data.map((item) {
      final id = item['id']?.toString() ?? '';
      final name = item['name']?.toString() ?? '';
      return {
        'value': id,
        'text': name,
        'id': id,
        'name': name,
      };
    }).toList();
  }

  /// Alias for fetchCookiesAndProvinces for cleaner naming
  Future<List<Map<String, String>>> fetchProvinces() =>
      fetchCookiesAndProvinces();

  /// Fetch the list of kabupaten/kota for a given province ID.
  Future<List<Map<String, String>>> fetchKabupatenKota(String provVal) async {
    final uri = Uri.parse('$_kabKotaUrl?prov=${Uri.encodeComponent(provVal)}');
    final response = await _client
        .get(
          uri,
          headers: _defaultHeaders,
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch cities: HTTP ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    final List<dynamic> data = decoded['data'] as List<dynamic>? ?? [];

    return data.map((item) {
      final id = item['id']?.toString() ?? '';
      final name = item['name']?.toString() ?? '';
      return {
        'value': id,
        'name': name,
        'id': id,
      };
    }).toList();
  }

  /// Fetch the monthly prayer schedule for a given location.
  Future<Map<String, dynamic>> fetchJadwalSholat(
    String provVal,
    String kabVal,
    String bulan,
    String tahun,
  ) async {
    final paddedMonth = bulan.padLeft(2, '0');
    final uri = Uri.parse(
      '$_jadwalUrl?prov=${Uri.encodeComponent(provVal)}&kabko=${Uri.encodeComponent(kabVal)}&thn=$tahun&bln=$paddedMonth',
    );

    final response = await _client
        .get(
          uri,
          headers: _defaultHeaders,
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch schedule: HTTP ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Close the HTTP client when disposing manually.
  void close() {
    _client.close();
  }
}
