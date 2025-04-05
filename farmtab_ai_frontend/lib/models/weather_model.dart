class WeatherPoint {
  final String time;
  final double temp;

  WeatherPoint({required this.time, required this.temp});

  factory WeatherPoint.fromJson(Map<String, dynamic> json) {
    return WeatherPoint(
      time: json['time'],
      temp: json['temp'].toDouble(),
    );
  }
}