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
    try {
      final response = await http.get(Uri.parse('$baseUrl/farms'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> farmsJson = data['data'];
        return farmsJson.map((json) => Farm.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load farms: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting farms: $e');
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

  // Create a new farm
  Future<Farm> createFarm(String title, String description, File? imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/farms'));

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
}