// lib/services/user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class UserService {
  static const String baseUrl = 'http://app.farmtab.my:4000'; // Replace with your API URL

  // Get user profile information
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      // Get the token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        throw Exception("No authentication token found");
      }

      // Make API request to get user profile
      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['user'];
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUserProfile: $e');
      throw e;
    }
  }

// Add other user-related API calls here
// For example: updateUserProfile, deleteUser, etc.
}