import 'dart:convert';

import 'package:http/http.dart' as http;

void sendTokenToBackend(String token) async {
  const String baseUrl = 'http://app.farmtab.my:4000';

  final response = await http.post(
    Uri.parse('$baseUrl/api/register-token'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'token': token}),
  );

  if (response.statusCode == 200) {
    print('✅ Token sent to backend');
  } else {
    print('❌ Failed to send token');
  }
}
