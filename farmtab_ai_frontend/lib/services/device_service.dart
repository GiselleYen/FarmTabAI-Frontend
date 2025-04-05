import 'dart:convert';
import 'package:http/http.dart' as http;

class DeviceService {
  static const String baseUrl = 'http://app.farmtab.my:4000/api';

  /// Get device by serial number
  static Future<Map<String, dynamic>> getDeviceBySerial(String serial) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/devices/$serial'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        return {}; // Not found
      } else {
        throw Exception('Failed to get device: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Get device by shelf ID
  static Future<Map<String, dynamic>> getDeviceByShelfId(int shelfId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/devices/by-shelf/$shelfId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        return {}; // No device for this shelf
      } else {
        throw Exception('Failed to get device by shelf: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Register a new device and link it to a shelf
  static Future<bool> registerDevice({required String serial, required int shelfId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/devices'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'serial_number': serial,
          'shelf_id': shelfId,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to register device: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<bool> updateDevice({required String serial, required int shelfId}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/devices/$shelfId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'serial_number': serial}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update device: ${response.body}');
    }
  }

  /// Update min-max values of device settings
  static Future<bool> updateDeviceSettings({
    required int shelfId,
    required double minPh,
    required double maxPh,
    required double minEc,
    required double maxEc,
    required double minTemp,
    required double maxTemp,
    required double minOrp,
    required double maxOrp,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/devices/by-shelf/$shelfId/settings'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'min_ph': minPh,
          'max_ph': maxPh,
          'min_ec': minEc,
          'max_ec': maxEc,
          'min_temperature': minTemp,
          'max_temperature': maxTemp,
          'min_orp': minOrp,
          'max_orp': maxOrp,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to update settings: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> getDeviceSettings(int shelfId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/devices/by-shelf/$shelfId/settings'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch settings: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

}
