import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/models/message.dart';

class ChatService {
  final String baseUrl = "http://124.243.133.42:3000";
  final String serialNumber = "UTC-510GP-ATB1E";
  final Duration apiTimeout = Duration(seconds: 180);
  final String sessionId;

  ChatService() : sessionId = "farmtab-session-${DateTime.now().millisecondsSinceEpoch}";

  Future<String> sendTextMessage(String userInput) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/generate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "prompt": userInput,
          "sessionId": sessionId,
          "serialNumber": serialNumber,
        }),
      ).timeout(apiTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? "I got a response, but it's unclear. How can I assist further?";
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<String> sendImageMessage(String userInput, File image) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/generate-with-image"),
      );

      // Add text fields
      request.fields['prompt'] = userInput;
      request.fields['sessionId'] = sessionId;
      request.fields['serialNumber'] = serialNumber;

      // Add image file
      final imageFile = await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(imageFile);

      // Send request
      final streamResponse = await request.send().timeout(apiTimeout);
      final response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? "I've analyzed your image, but I'm not sure what to say about it.";
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}