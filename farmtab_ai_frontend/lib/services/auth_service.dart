import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class AuthService {
  // Store tokens
  Future<void> _storeTokens(String accessToken, String idToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('access_token', accessToken);
    await prefs.setString('id_token', idToken);
    await prefs.setString('refresh_token', refreshToken);

    // Debugging: Check if tokens are actually saved
    String? storedToken = prefs.getString('access_token');
    print("✅ Stored Access Token: $storedToken");

    if (storedToken == null) {
      print("🚨 Token storage failed!");
    }
  }


  // Get stored access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Clear stored tokens (logout)
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('id_token');
    await prefs.remove('refresh_token');
  }

  // Register new user
  Future<Map<String, dynamic>> register(String email, String password, String name) async {
    final response = await http.post(
      Uri.parse('${Config.apiUrl}${Config.registerEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
      }),
    );

    return jsonDecode(response.body);
  }

  // Confirm registration with verification code
  Future<Map<String, dynamic>> confirmRegistration(String email, String confirmationCode) async {
    final response = await http.post(
      Uri.parse('${Config.apiUrl}${Config.confirmRegistrationEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'confirmationCode': confirmationCode,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> resendConfirmationCode(String email) async {
    final response = await http.post(
      Uri.parse('${Config.apiUrl}${Config.resendConfirmationCodeEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
      }),
    );

    return jsonDecode(response.body);
  }

  // Login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Config.apiUrl}${Config.loginEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['success'] && responseData['tokens'] != null) {
        print("Received Tokens: ${responseData['tokens']}");
        await _storeTokens(
          responseData['tokens']['accessToken'],
          responseData['tokens']['idToken'],
          responseData['tokens']['refreshToken'],
        );
      }

      return responseData;
    } else {
      // ✅ Handle non-200 responses
      return {'success': false, 'message': 'Login failed: ${response.body}'};
    }
  }

  // Forgot password - sends verification code
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('${Config.apiUrl}${Config.forgotPasswordEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
      }),
    );

    return jsonDecode(response.body);
  }

  // Confirm new password with verification code
  Future<Map<String, dynamic>> confirmForgotPassword(
      String email, String confirmationCode, String newPassword) async {
    final response = await http.post(
      Uri.parse('${Config.apiUrl}${Config.confirmForgotPasswordEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'confirmationCode': confirmationCode,
        'newPassword': newPassword,
      }),
    );

    return jsonDecode(response.body);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }

  // Make authenticated request
  Future<Map<String, dynamic>> authenticatedRequest(String endpoint, {Map<String, dynamic>? data, String method = 'GET'}) async {
    final token = await getAccessToken();

    if (token == null) {
      return {'success': false, 'message': 'Not authenticated'};
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    http.Response response;
    final uri = Uri.parse('${Config.apiUrl}$endpoint');

    if (method == 'GET') {
      response = await http.get(uri, headers: headers);
    } else {
      response = await http.post(
        uri,
        headers: headers,
        body: data != null ? jsonEncode(data) : null,
      );
    }

    return jsonDecode(response.body);
  }
}