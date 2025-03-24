import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// API Service for Device Registration
class DeviceService {
  // Replace with your actual EC2 endpoint
  static const String baseUrl = 'http://app.farmtab.my:4000/api';

  static Future<Map<String, dynamic>> getDeviceBySerial(String serial) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/devices/$serial'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        return {}; // Device not found
      } else {
        throw Exception('Failed to get device: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<bool> registerDevice(String serial) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/devices'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'serial_number': serial,
          // shelf_id will be null as requested
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
}