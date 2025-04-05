import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:farmtab_ai_frontend/models/farm_site.dart';

class FarmService {
  static const String baseUrl = 'http://app.farmtab.my:4000';

  // Get all farms
  Future<List<Farm>> getFarms() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('http://app.farmtab.my:4000/farms'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 👈 IMPORTANT
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      return jsonData.map((json) => Farm.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load farms: ${response.body}');
    }
  }

  // Get a farm by ID
  Future<Farm> getFarmById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/farms/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Farm.fromJson(data['data']);
      } else {
        throw Exception('Failed to load farm: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting farm: $e');
    }
  }

  Future<Farm> createFarm(String title, String description, File? imageFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        throw Exception("No authentication token found");
      }

      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/farms'));

      // ✅ Add token to headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields
      request.fields['title'] = title;
      request.fields['description'] = description;

      // Add image file if provided
      if (imageFile != null) {
        final fileExtension = imageFile.path.split('.').last;
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            contentType: MediaType('image', fileExtension),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Farm.fromJson(data['data']);
      } else {
        throw Exception('Failed to create farm: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating farm: $e');
    }
  }

  // Update a farm
  Future<Farm> updateFarm(int id, String title, String description, File? imageFile) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/farms/$id'));

      // Add text fields
      request.fields['title'] = title;
      request.fields['description'] = description;

      // Add image file if provided
      if (imageFile != null) {
        final fileExtension = imageFile.path.split('.').last;
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            contentType: MediaType('image', fileExtension),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Farm.fromJson(data['data']);
      } else {
        throw Exception('Failed to update farm: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating farm: $e');
    }
  }

  // Delete a farm
  Future<bool> deleteFarm(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/farms/$id'));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete farm: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting farm: $e');
    }
  }

  // Fetch average daily sensor data for a specific farm
  Future<Map<String, dynamic>> getAverageDailyConditions(int farmId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final response = await http.get(
        Uri.parse('$baseUrl/farms/$farmId/average-daily-conditions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        if (jsonBody['success'] == true) {
          return jsonBody['data'] as Map<String, dynamic>;
        } else {
          throw Exception('API error: ${jsonBody['message']}');
        }
      } else {
        throw Exception('Failed to fetch average daily data: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching average daily data: $e');
    }
  }

}