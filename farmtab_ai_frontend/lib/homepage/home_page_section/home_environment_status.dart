import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:intl/intl.dart';

import '../../services/weather_service.dart';

class HomeEnvironmentStatus extends StatefulWidget {
  const HomeEnvironmentStatus({super.key});

  @override
  State<HomeEnvironmentStatus> createState() => _HomeEnvironmentStatusState();
}

class _HomeEnvironmentStatusState extends State<HomeEnvironmentStatus> {
  List<int> showingTooltipOnSpots = [];
  List<FlSpot> weatherSpots = [];
  bool isLoading = true;
  List<String> tooltipLabels = [];

  final List<FlSpot> allSpots = const [
    FlSpot(0, 20),
    FlSpot(1, 25),
    FlSpot(2, 40),
    FlSpot(3, 50),
    FlSpot(4, 35),
    FlSpot(5, 40),
    FlSpot(6, 30),
    FlSpot(7, 20),
    FlSpot(8, 25),
    FlSpot(9, 40),
    FlSpot(10, 50),
    FlSpot(11, 35),
    FlSpot(12, 50),
    FlSpot(13, 60),
    FlSpot(14, 40),
    FlSpot(15, 50),
    FlSpot(16, 20),
    FlSpot(17, 25),
    FlSpot(18, 40),
    FlSpot(19, 50),
    FlSpot(20, 35),
    FlSpot(21, 80),
    FlSpot(22, 30),
    FlSpot(23, 20),
    FlSpot(24, 25),
    FlSpot(25, 40),
    FlSpot(26, 50),
    FlSpot(27, 35),
    FlSpot(28, 50),
    FlSpot(29, 60),
    FlSpot(30, 40),
  ];

  @override
  void initState() {
    super.initState();
    loadWeatherData();
  }

  Future<void> loadWeatherData() async {
    try {
      final data = await WeatherService.fetchForecast();

      final spots = <FlSpot>[];
      final timeLabels = <String>[];

      // Actual data points
      for (var i = 0; i < data.length; i++) {
        spots.add(FlSpot(i.toDouble(), data[i].temp));
        DateTime time = DateTime.parse(data[i].time);
        timeLabels.add(DateFormat('dd/MM HH:mm').format(time));
      }

      // Predicted points every 3 hours
      final DateTime lastTimestamp = DateTime.parse(data.last.time);
      double lastTemp = data.last.temp;

      for (int i = 1; i <= 5; i++) {
        double predictedTemp = lastTemp + i * 0.3;
        DateTime futureTime = lastTimestamp.add(Duration(hours: 3 * i));
        spots.add(FlSpot((data.length + i - 1).toDouble(), predictedTemp));
        timeLabels.add(DateFormat('dd/MM HH:mm').format(futureTime));
      }

      setState(() {
        weatherSpots = spots;
        tooltipLabels = timeLabels;
        showingTooltipOnSpots = [spots.length - 1];
        isLoading = false;
      });
    } catch (e) {
      print("Error loading weather data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {//
    final media = MediaQuery.of(context).size;
    print(weatherSpots);
    final dataSpots = weatherSpots.isNotEmpty ? weatherSpots : allSpots;

    final lineChartBar = LineChartBarData(
      showingIndicators: showingTooltipOnSpots,
      spots: dataSpots,
      isCurved: false,
      barWidth: 3,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            TColor.primaryColor2.withOpacity(0.4),
            TColor.primaryColor1.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      gradient: LinearGradient(colors: TColor.primaryG),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Environment Status",
          style: TextStyle(
            color: TColor.primaryColor1,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: media.width * 0.04),
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            height: media.width * 0.4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: TColor.primaryColor2.withOpacity(0.3),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                  child: Row(
                    children: [
                      Transform.translate(
                      offset: const Offset(0, -35),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Colors.orange, Colors.redAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.thermostat,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Temperature",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Text(
                            "${dataSpots.isNotEmpty ? dataSpots.last.y.toStringAsFixed(1) : '--'}°C",
                            style: TextStyle(
                              color: TColor.primaryColor1,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                LineChart(
                  LineChartData(
                    showingTooltipIndicators: showingTooltipOnSpots.map((index) {
                      return ShowingTooltipIndicators([
                        LineBarSpot(lineChartBar, 0, lineChartBar.spots[index]),
                      ]);
                    }).toList(),
                    lineTouchData: LineTouchData(
                      enabled: true,
                      handleBuiltInTouches: false,
                      touchCallback: (event, response) {
                        if (response == null || response.lineBarSpots == null) return;
                        if (event is FlTapUpEvent) {
                          final spotIndex = response.lineBarSpots!.first.spotIndex;
                          setState(() {
                            showingTooltipOnSpots = [spotIndex];
                          });
                        }
                      },
                      mouseCursorResolver: (event, response) {
                        return response?.lineBarSpots != null
                            ? SystemMouseCursors.click
                            : SystemMouseCursors.basic;
                      },
                      getTouchedSpotIndicator: (barData, indexes) {
                        return indexes.map((index) {
                          return TouchedSpotIndicatorData(
                            FlLine(color: Colors.red),
                            FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                                radius: 3,
                                color: Colors.white,
                                strokeWidth: 3,
                                strokeColor: TColor.secondaryColor1,
                              ),
                            ),
                          );
                        }).toList();
                      },
                      touchTooltipData: LineTouchTooltipData(
                        tooltipRoundedRadius: 20,
                        getTooltipItems: (spots) => spots.map((spot) {
                          final int index = spot.x.toInt();
                          final String label = (index < tooltipLabels.length)
                              ? tooltipLabels[index]
                              : "${spot.x.toInt()} mins";

                          return LineTooltipItem(
                            "$label\n${spot.y.toStringAsFixed(1)}°C",
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    lineBarsData: [lineChartBar],
                    minY: 0,
                    maxY: 130,
                    titlesData: FlTitlesData(show: false),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: true, border: Border.all(color: Colors.transparent)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
