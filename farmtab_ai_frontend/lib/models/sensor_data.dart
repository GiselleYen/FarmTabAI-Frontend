class SensorData {
  final String serial;
  final double ph;
  final double ec;
  final double temp;
  final int orp;
  final Map<String, dynamic> phStatus;
  final Map<String, dynamic> ecStatus;
  final Map<String, dynamic> tempStatus;
  final Map<String, dynamic> orpStatus;
  final String timestamp;

  SensorData({
    required this.serial,
    required this.ph,
    required this.ec,
    required this.temp,
    required this.orp,
    required this.phStatus,
    required this.ecStatus,
    required this.tempStatus,
    required this.orpStatus,
    required this.timestamp,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      serial: json['serial'] ?? '',
      ph: (json['ph'] ?? 0.0).toDouble(),
      ec: (json['ec'] ?? 0.0).toDouble(),
      temp: (json['temp'] ?? 0.0).toDouble(),
      orp: (json['orp'] ?? 0) is int ? (json['orp'] ?? 0) : (json['orp'] ?? 0).toInt(),
      phStatus: json['phStatus'] ?? {'text': 'No Data', 'color': 'grey'},
      ecStatus: json['ecStatus'] ?? {'text': 'No Data', 'color': 'grey'},
      tempStatus: json['tempStatus'] ?? {'text': 'No Data', 'color': 'grey'},
      orpStatus: json['orpStatus'] ?? {'text': 'No Data', 'color': 'grey'},
      timestamp: json['timestamp'] ?? '',
    );
  }
}