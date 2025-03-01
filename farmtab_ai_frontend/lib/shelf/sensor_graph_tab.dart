import 'package:farmtab_ai_frontend/shelf/shelf_widget/data_graph.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class SensorGraphsTab extends StatefulWidget {
  @override
  _SensorGraphsTabState createState() => _SensorGraphsTabState();
}

class _SensorGraphsTabState extends State<SensorGraphsTab> with SingleTickerProviderStateMixin {
  late TabController _graphTabController;

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
    _graphTabController = TabController(length: 3, vsync: this);
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
        TabBar(
          controller: _graphTabController,
          tabs: [
            Tab(text: 'pH'),
            Tab(text: 'EC'),
            Tab(text: 'TDS'),
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
          child: TabBarView(
            controller: _graphTabController,
            children: [
              SensorGraphWidget(
                values: [6.8, 7.1, 7.2, 6.9, 6.7, 7.0, 7.3, 7.4],
                startTime: DateTime.now().subtract(Duration(hours: 6 * 7)),
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
                values: [1.2, 1.5, 1.8, 2.1, 2.3, 2.0, 1.9, 1.7],
                startTime: DateTime.now().subtract(Duration(hours: 6 * 7)),
                hoursInterval: 6,
                title: 'EC Value',
                minY: 0,
                maxY: 5,
                referenceLineValue: 2.0,
                referenceLineLabel: 'Optimal',
                primaryColor: Colors.green,
                secondaryColor: Colors.amber,
                unit: ' mS/cm',
                valueCategories: {
                  'Low': [0.0, 1.4, Colors.purple],
                  'Ideal': [1.5, 2.5, Colors.green],
                  'High': [2.6, 5.0, Colors.orange],
                },
              ),
              _buildLineChart(
                tdsData,
                'TDS Graph',
                'TDS (ppm)',
                TColor.primaryColor2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}