import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SensorService {
  static const String baseUrl = 'http://app.farmtab.my:4000/api';

  Future<Map<String, dynamic>> fetchLatestSensorData(int shelfId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/sensors/readings/$shelfId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load sensor data: ${response.statusCode}');
    }
  }

  // ✅ Get historical sensor data
  Future<Map<String, dynamic>> fetchHistoricalSensorData({
    required int shelfId,
    int hours = 48,
    String interval = '1h',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final uri = Uri.parse(
      '$baseUrl/sensors/readings/historical/$shelfId?hours=$hours&interval=$interval',
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load historical sensor data: ${response.statusCode}');
    }
  }
}
