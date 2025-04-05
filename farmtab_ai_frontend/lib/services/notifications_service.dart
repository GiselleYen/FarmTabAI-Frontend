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

class NotificationsService {
  static const String baseUrl = 'http://app.farmtab.my:4000';

  Future<List<Map<String, dynamic>>> fetchOrgNotifications(String orgId) async {
    const String baseUrl = 'http://app.farmtab.my:4000';
    final response = await http.get(
      Uri.parse('$baseUrl/api/alerts/organization/$orgId'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load alerts');
    }
  }


}