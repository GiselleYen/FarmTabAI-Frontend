import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import '../models/shelf.dart';

class ShelfService {
  static const String baseUrl = 'http://app.farmtab.my:4000';

  Future<List<Shelf>> getShelvesByFarmId(int farmId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/shelves/farm/$farmId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      return jsonData.map((json) => Shelf.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load shelves: ${response.body}');
    }
  }

  Future<Shelf> getShelfById(int shelfId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/shelves/$shelfId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Shelf.fromJson(data);
    } else {
      throw Exception('Failed to fetch shelf: ${response.body}');
    }
  }

  Future<Shelf> createShelf({
    required int farmId,
    required String name,
    required String subtitle,
    required String plantType,
    required int harvestDays,
    File? imageFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/shelves'));
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['subtitle'] = subtitle;
    request.fields['plant_type'] = plantType;
    request.fields['harvest_days'] = harvestDays.toString();
    request.fields['farm_id'] = farmId.toString();

    if (imageFile != null) {
      final fileExtension = extension(imageFile.path).toLowerCase();
      final contentType = fileExtension == '.png'
          ? 'image/png'
          : fileExtension == '.gif'
          ? 'image/gif'
          : 'image/jpeg';

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType.parse(contentType),
        filename: basename(imageFile.path),
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Shelf.fromJson(data['data']);
    } else {
      throw Exception('Failed to create shelf: ${response.body}');
    }
  }

  Future<Shelf> updateShelf({
    required int shelfId,
    required String name,
    required String subtitle,
    required String plantType,
    required int harvestDays,
    File? imageFile,
    bool? isFavourite,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final uri = Uri.parse('$baseUrl/shelves/$shelfId');
    var request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['subtitle'] = subtitle;
    request.fields['plant_type'] = plantType;
    request.fields['harvest_days'] = harvestDays.toString();

    if (isFavourite != null) {
      request.fields['is_favourite'] = isFavourite.toString();
    }

    if (imageFile != null) {
      final ext = extension(imageFile.path).toLowerCase();
      final contentType = ext == '.png'
          ? 'image/png'
          : ext == '.gif'
          ? 'image/gif'
          : 'image/jpeg';

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType.parse(contentType),
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return Shelf.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to update shelf: ${response.body}');
    }
  }

  Future<Shelf> updatePassedDays({
    required int shelfId,
    required int passedDays,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.patch(
      Uri.parse('$baseUrl/shelves/$shelfId/passed-days'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'passed_days': passedDays,
      }),
    );

    if (response.statusCode == 200) {
      return Shelf.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to update passed days: ${response.body}');
    }
  }

  Future<void> deleteShelf(int shelfId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.delete(
      Uri.parse('$baseUrl/shelves/$shelfId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete shelf: ${response.body}');
    }
  }

  Future<List<Shelf>> getFavoriteShelves() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/shelves/favorites'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Shelf.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load favorite shelves');
    }
  }

  Future<void> resetPassedDays(int shelfId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.put(
      Uri.parse('$baseUrl/shelves/$shelfId/reset-passed-days'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reset passed days: ${response.body}');
    }
  }

}
