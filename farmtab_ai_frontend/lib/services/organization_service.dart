import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/organization.dart';

class OrganizationService {

  static const String baseUrl = 'http://app.farmtab.my:4000';

  // Organizations
  Future<List<Organization>> getOrganizations() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/organizations'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Check if the response is directly a list or nested in an object
      List<dynamic> organizationsJson;

      if (data is List) {
        organizationsJson = data;
      } else if (data is Map && data.containsKey('organizations')) {
        organizationsJson = data['organizations'] as List;
      } else if (data is Map && data.containsKey('success')) {
        if (data['success'] && data['organizations'] != null) {
          organizationsJson = data['organizations'] as List;
        } else {
          throw Exception('Failed to parse organizations: ${response.body}');
        }
      } else {
        throw Exception('Unexpected response format: ${response.body}');
      }

      return organizationsJson.map((json) => Organization.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load organizations: ${response.body}');
    }
  }

  Future<Organization> getOrganizationById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse('$baseUrl/organizations/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Organization.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load organization: ${response.body}');
    }
  }

  Future<Organization> createOrganization(Organization organization) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.post(
      Uri.parse('$baseUrl/organizations'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(organization.toJson()),
    );

    if (response.statusCode == 201) {
      return Organization.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create organization: ${response.body}');
    }
  }

  Future<Organization> updateOrganization(String id, Organization organization) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.put(
      Uri.parse('$baseUrl/organizations/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(organization.toJson()),
    );

    if (response.statusCode == 200) {
      return Organization.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update organization: ${response.body}');
    }
  }

  Future<void> deleteOrganization(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.delete(
      Uri.parse('$baseUrl/organizations/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete organization: ${response.body}');
    }
  }

}