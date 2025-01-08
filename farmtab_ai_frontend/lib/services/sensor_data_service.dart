import 'dart:convert';
import 'package:http/http.dart' as http;

class SensorService {
  static const String baseUrl = 'http://43.217.51.84:3010/api';  // Replace with your EC2 IP

  Future<Map<String, dynamic>> getLatestTemperature() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/temperature/latest'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load temperature data');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
}
