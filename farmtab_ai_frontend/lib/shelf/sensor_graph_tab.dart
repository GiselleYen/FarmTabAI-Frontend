import 'package:farmtab_ai_frontend/shelf/shelf_widget/data_graph.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

import '../services/sensor_services.dart';

class SensorGraphsTab extends StatefulWidget {
  final int shelfId;
  final bool currentSetting;

  const SensorGraphsTab({Key? key, required this.shelfId, required this.currentSetting}) : super(key: key);

  @override
  _SensorGraphsTabState createState() => _SensorGraphsTabState();
}


class _SensorGraphsTabState extends State<SensorGraphsTab> with SingleTickerProviderStateMixin {
  late TabController _graphTabController;
  bool _isLoading = true;
  Map<String, List<FlSpot>> sensorSpots = {};
  DateTime? _startTime;

  // Sample data - replace with your actual historical data
  final List<FlSpot> phData = [
    FlSpot(0, 6.5),
    FlSpot(1, 6.7),
    FlSpot(2, 6.2),
    FlSpot(3, 6.8),
    FlSpot(4, 6.4),
    FlSpot(5, 6.6),
    FlSpot(6, 6.3),
  ];

  final List<FlSpot> ecData = [
    FlSpot(0, 1.2),
    FlSpot(1, 1.3),
    FlSpot(2, 1.1),
    FlSpot(3, 1.4),
    FlSpot(4, 1.2),
    FlSpot(5, 1.3),
    FlSpot(6, 1.2),
  ];

  final List<FlSpot> tdsData = [
    FlSpot(0, 500),
    FlSpot(1, 520),
    FlSpot(2, 480),
    FlSpot(3, 550),
    FlSpot(4, 510),
    FlSpot(5, 530),
    FlSpot(6, 500),
  ];

  @override
  void initState() {
    super.initState();
    _graphTabController = TabController(length: 4, vsync: this);
    _fetchHistoricalData();
  }

  Future<void> _fetchHistoricalData() async {
    try {
      final service = SensorService();
      final data = await service.fetchHistoricalSensorData(
        shelfId: widget.shelfId,
        hours: 48,
        interval: '6h',
      );

      final List<dynamic> rawData = data['data'];
      if (rawData.isEmpty) return;

      DateTime firstTime = DateTime.parse(rawData.first['timestamp']);

      List<FlSpot> generateSpots(String key) {
        return rawData.asMap().entries.map((entry) {
          final index = entry.key.toDouble();
          final value = entry.value[key];
          if (value == null) return null;
          return FlSpot(index, value.toDouble());
        }).whereType<FlSpot>().toList();
      }

      setState(() {
        _startTime = firstTime;
        sensorSpots['ph'] = generateSpots('ph');
        sensorSpots['ec'] = generateSpots('ec');
        sensorSpots['temp'] = generateSpots('temp');
        sensorSpots['orp'] = generateSpots('orp');
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching historical data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _graphTabController.dispose();
    super.dispose();
  }

  Widget _buildLineChart(List<FlSpot> spots, String title, String yAxisLabel, Color lineColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 440,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  // Customize grid color
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    // Increase bottom margin to make space for x-axis label
                    axisNameSize: 40,  // Add space for axis label
                    axisNameWidget:
                      Text(
                        'Time',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      // Customize time labels color
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}h',
                          style: TextStyle(
                            color: Colors.black87,  // Time labels color
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(
                      yAxisLabel,
                      style: TextStyle(fontSize: 12),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(1),
                          style: TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: lineColor,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: lineColor.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.currentSetting)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red.shade100,

            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: Colors.red.shade800),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "You haven't set the optimal range yet. Please set and save your settings.",
                    style: TextStyle(
                      color: Colors.red.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        TabBar(
          controller: _graphTabController,
          tabs: [
            Tab(text: 'pH'),
            Tab(text: 'EC'),
            Tab(text: 'Temp'),
            Tab(text: 'ORP'),
          ],
          labelColor: TColor.primaryColor1,
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 3.0,  // Thickness of the indicator line
              color: TColor.primaryColor1,  // Color of the indicator
            ),
            insets: EdgeInsets.symmetric(horizontal: 26.0),  // Padding from the edges
          ),
        ),
        Expanded(
          child: _isLoading || _startTime == null
              ? Center(child: CircularProgressIndicator())
              : TabBarView(
            controller: _graphTabController,
            children: [
              SensorGraphWidget(
                values: sensorSpots['ph']?.map((e) => e.y).toList() ?? [],
                startTime: _startTime!,
                hoursInterval: 6,
                title: 'pH Levels',
                minY: 0,
                maxY: 14,
                referenceLineValue: 7,
                referenceLineLabel: 'Neutral',
                primaryColor: Colors.green,
                secondaryColor: Colors.teal,
                unit: '',
                valueCategories: {
                  'Acidic': [0.0, 6.9, Colors.red],
                  'Neutral': [7.0, 7.0, Colors.grey],
                  'Alkaline': [7.1, 14.0, Colors.blue],
                },
              ),
              SensorGraphWidget(
                values: sensorSpots['ec']?.map((e) => e.y).toList() ?? [],
                startTime: _startTime!,
                hoursInterval: 6,
                title: 'EC Value',
                minY: 10,
                maxY: 200,
                referenceLineValue: 30.0,
                referenceLineLabel: 'Optimal',
                primaryColor: Colors.green,
                secondaryColor: Colors.amber,
                unit: ' mS/cm',
                valueCategories: {
                  'Low': [0.0, 50.0, Colors.purple],
                  'Ideal': [51.0, 100.0, Colors.green],
                  'High': [101.0, 150.0, Colors.orange],
                },
              ),
              SensorGraphWidget(
                values: sensorSpots['temp']?.map((e) => e.y).toList() ?? [],
                startTime: _startTime!,
                hoursInterval: 6,
                title: 'Temperature',
                minY: 10,
                maxY: 40,
                referenceLineValue: 26.0,
                referenceLineLabel: 'Optimal',
                primaryColor: Colors.orange,
                secondaryColor: Colors.deepOrange,
                unit: '°C',
                valueCategories: {
                  'Cold': [10.0, 20.0, Colors.blue],
                  'Normal': [20.1, 28.0, Colors.green],
                  'Hot': [28.1, 40.0, Colors.red],
                },
              ),
              SensorGraphWidget(
                values: sensorSpots['orp']?.map((e) => e.y).toList() ?? [],
                startTime: _startTime!,
                hoursInterval: 6,
                title: 'ORP Levels',
                minY: 0,
                maxY: 100,
                referenceLineValue: 300,
                referenceLineLabel: 'Ideal',
                primaryColor: Colors.indigo,
                secondaryColor: Colors.blueAccent,
                unit: ' mV',
                valueCategories: {
                  'Low': [0.0, 30.0, Colors.orange],
                  'Ideal': [31.0, 65.0, Colors.green],
                  'High': [66.0, 100.0, Colors.red],
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}