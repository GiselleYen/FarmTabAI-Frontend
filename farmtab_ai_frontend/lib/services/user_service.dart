// lib/services/user_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';

import '../models/user.dart';
import 'auth_exception.dart'; // Add this import

class UserService {
  static const String baseUrl = 'http://app.farmtab.my:4000';

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        throw UnauthorizedException("No authentication token found");
      }

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
      } else if (response.statusCode == 401) {
        // Token is expired or invalid
        throw UnauthorizedException('Session expired');
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUserProfile: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> updateUserName(String username) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        throw Exception("No authentication token found");
      }

      final response = await http.put(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "username": username, // Send only the name field
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to update name: ${response.body}');
      }
    } catch (e) {
      print('Error in updateUserName: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> updateUserBio(String bio) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        throw Exception("No authentication token found");
      }

      final response = await http.put(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "bio": bio,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to update bio: ${response.body}');
      }
    } catch (e) {
      print('Error in updateUserBio: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> uploadProfileImage(File imageFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        throw Exception("No authentication token found");
      }

      // Get file extension and convert to lowercase
      final String fileExtension = extension(imageFile.path).toLowerCase();

      // Determine MIME type based on file extension
      String mimeType;
      switch (fileExtension) {
        case '.jpg':
        case '.jpeg':
          mimeType = 'image/jpeg';
          break;
        case '.png':
          mimeType = 'image/png';
          break;
        case '.gif':
          mimeType = 'image/gif';
          break;
        default:
          throw Exception('Unsupported image format. Please use JPG, PNG, or GIF');
      }

      // Create multipart request
      var uri = Uri.parse('$baseUrl/user/profile/image');
      var request = http.MultipartRequest('POST', uri);

      // Add token to headers
      request.headers['Authorization'] = 'Bearer $token';

      // Create multipart file with explicit content type
      var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      // Make sure filename has correct extension
      String filename = basename(imageFile.path);
      if (!filename.toLowerCase().endsWith(fileExtension)) {
        filename += fileExtension;
      }

      var multipartFile = http.MultipartFile(
          'profileImage',
          stream,
          length,
          filename: filename,
          contentType: MediaType.parse(mimeType)  // Explicitly set content type
      );

      request.files.add(multipartFile);

      // Show request details for debugging
      print('Uploading file: ${multipartFile.filename}');
      print('Content type: ${multipartFile.contentType.toString()}');

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to upload image: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in uploadProfileImage: $e');
      throw e;
    }
  }
  // Get all users
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/getUsers'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Assign user to organization
  Future<User> assignUserToOrganization(String userId, String? organizationId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/user/$userId/organization'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'organizationId': organizationId}),
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to assign organization: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Update user role
  Future<User> updateUserRole(String userId, String role) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/user/$userId/role'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'role': role}),
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update role: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<int> getUnreadNotificationCount(int userId, int organizationID) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/alerts/unread-count/$userId/org/$organizationID'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['unreadCount'] ?? 0;
    } else {
      print('❌ Failed to fetch unread count: ${response.body}');
      return 0;
    }
  }

  Future<int> getUserId() async {
    final user = await getUserProfile();
    final id = user['user_id'];
    if (id is int) return id;
    if (id is String) return int.tryParse(id) ?? -1;
    throw Exception("Invalid user ID format");
  }

}