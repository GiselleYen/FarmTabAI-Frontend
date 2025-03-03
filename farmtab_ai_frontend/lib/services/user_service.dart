// lib/services/user_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart'; // Add this import

class UserService {
  static const String baseUrl = 'http://app.farmtab.my:4000';

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        throw Exception("No authentication token found");
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
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUserProfile: $e');
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

      // Print debug info
      print('File path: ${imageFile.path}');
      print('File extension: $fileExtension');
      print('MIME type: $mimeType');

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
}