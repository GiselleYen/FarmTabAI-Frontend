// lib/models/sensor_data.dart
class SensorData {
  final double ph;
  final double ec;
  final DateTime timestamp;
  final String phStatusText;
  final String phStatusColor;
  final String ecStatusText;
  final String ecStatusColor;

  SensorData({
    required this.ph,
    required this.ec,
    required this.timestamp,
    required this.phStatusText,
    required this.phStatusColor,
    required this.ecStatusText,
    required this.ecStatusColor,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      ph: json['ph']?.toDouble() ?? 0.0,
      ec: json['ec']?.toDouble() ?? 0.0,
      timestamp: DateTime.parse(json['timestamp']),
      phStatusText: json['phStatus']['text'],
      phStatusColor: json['phStatus']['color'],
      ecStatusText: json['ecStatus']['text'],
      ecStatusColor: json['ecStatus']['color'],
    );
  }
}