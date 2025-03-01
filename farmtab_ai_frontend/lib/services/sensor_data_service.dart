import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/sensor_data.dart';


class SensorDataService {

  final String apiUrl = 'http://app.farmtab.my:3010/latest-sensor-data';

  Future<SensorData> getLatestData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return SensorData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sensor data');
    }
  }
}
