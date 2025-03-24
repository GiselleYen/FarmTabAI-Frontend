import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SensorService {
  static const String baseUrl = 'http://app.farmtab.my:4000/api';

  /// Fetch the latest sensor data (pH, EC)
  Future<Map<String, dynamic>> fetchLatestSensorData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/sensors/readings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load sensor data');
    }
  }

  /// Send calibration value for either pH or EC sensor
  Future<bool> sendCalibrationData({
    required String sensorType,
    required double value,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = Uri.parse('$baseUrl/calibrate');
      final body = jsonEncode({
        'sensorType': sensorType, // ✅ camelCase
        'calibratedValue': value, // ✅ camelCase
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Server responded with status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Calibration request failed: $e');
    }
  }
}
