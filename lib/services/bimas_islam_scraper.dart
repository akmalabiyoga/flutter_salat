import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

class BimasIslamScraper {
  static const String _baseUrl =
      'https://bimasislam.kemenag.go.id/jadwalshalat';
  static const String _kabKotaUrl =
      'https://bimasislam.kemenag.go.id/ajax/getKabkoshalat';
  static const String _jadwalUrl =
      'https://bimasislam.kemenag.go.id/ajax/getShalatbln';

  static const Map<String, String> _defaultHeaders = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36',
  };

  final Map<String, String> _cookies = {};

  String get _cookieString {
    return _cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
  }

  void _updateCookies(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      String cookieStr = (index == -1)
          ? rawCookie
          : rawCookie.substring(0, index);
      var parts = cookieStr.split('=');
      if (parts.length == 2) {
        _cookies[parts[0]] = parts[1];
      }
    }
  }

  /// Perform the two-request handshake to obtain cookies and province list.
  Future<List<Map<String, String>>> fetchCookiesAndProvinces() async {
    // First request - grab session cookies
    var response = await http.get(
      Uri.parse(_baseUrl),
      headers: _defaultHeaders,
    );
    _updateCookies(response);

    // Second request - page is fully populated with province <select>
    var headers = Map<String, String>.from(_defaultHeaders);
    if (_cookies.isNotEmpty) headers['Cookie'] = _cookieString;

    response = await http.get(Uri.parse(_baseUrl), headers: headers);

    var document = html_parser.parse(response.body);
    var provSelect = document.getElementById('search_prov');

    List<Map<String, String>> provinces = [];
    if (provSelect != null) {
      for (var option in provSelect.querySelectorAll('option')) {
        String val = option.attributes['value'] ?? '';
        String text = option.text.trim();
        if (val.isNotEmpty) {
          // skip placeholder
          provinces.add({'value': val, 'text': text});
        }
      }
    }
    return provinces;
  }

  /// Fetch the list of kabupaten/kota for a given province value.
  Future<List<Map<String, String>>> fetchKabupatenKota(String provVal) async {
    if (_cookies.isEmpty) {
      await fetchCookiesAndProvinces();
    }

    var headers = Map<String, String>.from(_defaultHeaders);
    headers['Content-Type'] = 'application/x-www-form-urlencoded';
    if (_cookies.isNotEmpty) headers['Cookie'] = _cookieString;

    var response = await http.post(
      Uri.parse(_kabKotaUrl),
      headers: headers,
      body: {'x': provVal},
    );

    if (response.statusCode != 200) throw Exception('Failed to fetch cities');

    var document = html_parser.parse(response.body);
    List<Map<String, String>> cities = [];

    for (var option in document.querySelectorAll('option')) {
      String val = option.attributes['value'] ?? '';
      String text = option.text.trim();
      if (val.isNotEmpty) {
        cities.add({'value': val, 'name': text});
      }
    }
    return cities;
  }

  /// Fetch the monthly prayer schedule for a given location.
  Future<Map<String, dynamic>> fetchJadwalSholat(
    String provVal,
    String kabVal,
    String bulan,
    String tahun,
  ) async {
    if (_cookies.isEmpty) {
      await fetchCookiesAndProvinces();
    }

    var headers = Map<String, String>.from(_defaultHeaders);
    headers['Content-Type'] = 'application/x-www-form-urlencoded';
    if (_cookies.isNotEmpty) headers['Cookie'] = _cookieString;

    var response = await http.post(
      Uri.parse(_jadwalUrl),
      headers: headers,
      body: {'x': provVal, 'y': kabVal, 'bln': bulan, 'thn': tahun},
    );

    if (response.statusCode != 200) throw Exception('Failed to fetch schedule');

    return jsonDecode(response.body);
  }
}
