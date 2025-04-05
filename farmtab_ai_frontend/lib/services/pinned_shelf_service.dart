import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PinnedShelfService {
  static const String baseUrl = 'http://app.farmtab.my:4000';

  /// Get all pinned shelves (up to 5) for the organization
  Future<List<dynamic>> getPinnedShelves() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) return [];

      final response = await http.get(
        Uri.parse('$baseUrl/pinned-shelf'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return jsonDecode(response.body); // returns a List<dynamic>
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching pinned shelves: $e');
      return [];
    }
  }

  /// Pin a shelf (limit 5)
  Future<bool> pinShelf(int shelfId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/pinned-shelf'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"shelf_id": shelfId}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error pinning shelf: $e');
      return false;
    }
  }

  /// Unpin a specific shelf by shelfId
  Future<bool> unpinShelf(int shelfId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final response = await http.delete(
        Uri.parse('$baseUrl/pinned-shelf/$shelfId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error unpinning shelf: $e');
      return false;
    }
  }
}
