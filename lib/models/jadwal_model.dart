class JadwalData {
  final String prayerDate;
  final String prayerTime;
  final String prayerName;
  final String kabupatenKotaName;
  final String provinsiName;

  JadwalData({
    required this.prayerDate,
    required this.prayerTime,
    required this.prayerName,
    required this.kabupatenKotaName,
    required this.provinsiName,
  });

  factory JadwalData.fromJson(Map<String, dynamic> json) {
    return JadwalData(
      prayerDate: json['prayer_date'] ?? '',
      prayerTime: json['prayer_time'] ?? '',
      prayerName: json['prayer_name'] ?? '',
      kabupatenKotaName: json['kabupaten_kota_name'] ?? '',
      provinsiName: json['provinsi_name'] ?? '',
    );
  }
}

class JadwalResponse {
  final int status;
  final String message;
  final List<JadwalData> data;

  JadwalResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JadwalResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List? ?? [];
    List<JadwalData> data = dataList.map((i) => JadwalData.fromJson(i)).toList();

    return JadwalResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: data,
    );
  }
}
