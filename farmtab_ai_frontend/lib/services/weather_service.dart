import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static Future<List<WeatherPoint>> fetchForecast() async {
    final url = Uri.parse('http://app.farmtab.my:4000/api/weather/forecast');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['forecast'] as List)
          .map((item) => WeatherPoint.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
