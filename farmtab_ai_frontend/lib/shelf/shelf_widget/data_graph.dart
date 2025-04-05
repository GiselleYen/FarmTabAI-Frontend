import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SensorGraphWidget extends StatefulWidget {
  final List<double> values;
  final DateTime startTime;
  final int hoursInterval;
  final String title;
  final double minY;
  final double maxY;
  final double referenceLineValue;
  final String referenceLineLabel;
  final Color primaryColor;
  final Color secondaryColor;
  final String unit;
  final Map<String, List<dynamic>> valueCategories;

  const SensorGraphWidget({
    Key? key,
    required this.values,
    required this.startTime,
    this.hoursInterval = 6,
    required this.title,
    required this.minY,
    required this.maxY,
    this.referenceLineValue = -1, // -1 means no reference line
    this.referenceLineLabel = '',
    required this.primaryColor,
    required this.secondaryColor,
    this.unit = '',
    required this.valueCategories,
  }) : super(key: key);

  @override
  State<SensorGraphWidget> createState() => _SensorGraphWidgetState();
}

class _SensorGraphWidgetState extends State<SensorGraphWidget> {
  String getCategoryForValue(double value) {
    for (final entry in widget.valueCategories.entries) {
      final min = entry.value[0] as double;
      final max = entry.value[1] as double;
      if (value >= min && value <= max) {
        return entry.key;
      }
    }
    return 'Unknown';
  }

  Color getColorForValue(double value) {
    for (final entry in widget.valueCategories.entries) {
      final min = entry.value[0] as double;
      final max = entry.value[1] as double;
      if (value >= min && value <= max) {
        return entry.value[2] as Color;
      }
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.title} (Updated Every ${widget.hoursInterval} Hours)',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: widget.values.length.toDouble() - 1,
                minY: widget.minY,
                maxY: widget.maxY,
                backgroundColor: Colors.transparent,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      widget.values.length,
                          (index) => FlSpot(index.toDouble(), widget.values[index]),
                    ),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        widget.primaryColor,
                        widget.secondaryColor,
                      ],
                    ),
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          widget.primaryColor.withOpacity(0.2),
                          widget.secondaryColor.withOpacity(0.2),
                        ],
                      ),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: getColorForValue(spot.y),
                          strokeWidth: 1,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                  ),
                  // Reference line if needed
                  if (widget.referenceLineValue >= 0)
                    LineChartBarData(
                      spots: [
                        FlSpot(0, widget.referenceLineValue),
                        FlSpot(widget.values.length.toDouble() - 1, widget.referenceLineValue),
                      ],
                      isCurved: false,
                      color: Colors.grey.withOpacity(0.5),
                      barWidth: 1,
                      dotData: FlDotData(show: false),
                      dashArray: [5, 5],
                    ),
                ],
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    // Make the reference line slightly darker if it exists
                    final color = (widget.referenceLineValue >= 0 && value == widget.referenceLineValue)
                        ? Colors.grey.shade400
                        : Colors.grey.shade200;
                    return FlLine(
                      color: color,
                      strokeWidth: (widget.referenceLineValue >= 0 && value == widget.referenceLineValue) ? 1.2 : 0.8,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 0.8,
                    );
                  },
                  horizontalInterval: (widget.maxY - widget.minY) / 7, // Divide the range into approximately 7 intervals
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 25,
                      getTitlesWidget: (value, meta) {
                        // Only show some values to avoid crowding
                        if (value % ((widget.maxY - widget.minY) / 4) != 0 &&
                            value != widget.referenceLineValue) return Container();

                        // Special formatting for the reference line
                        final isReference = widget.referenceLineValue >= 0 &&
                            value == widget.referenceLineValue;

                        return Text(
                          '${value.toStringAsFixed(1)}',
                          style: TextStyle(
                            color: isReference ? Colors.black : Colors.grey.shade600,
                            fontSize: 9,
                            fontWeight: isReference ? FontWeight.bold : FontWeight.normal,
                          ),
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
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 16,
                      getTitlesWidget: (value, meta) {
                        final int index = value.toInt();
                        if (index >= widget.values.length) return Container();

                        // Calculate time based on specified hour intervals
                        final DateTime pointTime = widget.startTime.add(Duration(hours: widget.hoursInterval * index));
                        final String hourStr = pointTime.hour.toString().padLeft(2, '0');

                        // Show fewer time labels to prevent overcrowding
                        if (index % 4 == 0 || index == widget.values.length - 1) {
                          return Text(
                            "$hourStr:00",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 9,
                            ),
                          );
                        }

                        return Container();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    tooltipRoundedRadius: 8,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          // Only show tooltips for the main line
                          if (barSpot.bar.barWidth != 3) return null;

                          final DateTime pointTime = widget.startTime.add(
                            Duration(hours: widget.hoursInterval * barSpot.x.toInt()),
                          );
                          final category = getCategoryForValue(barSpot.y);

                          return LineTooltipItem(
                            '${pointTime.day}/${pointTime.month} ${pointTime.hour}:00\n',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: '${widget.title}: ${barSpot.y.toStringAsFixed(1)}${widget.unit}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' ($category)',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      }
                  ),
                ),
              ),
            ),
          ),
          // Legend for value categories
          SizedBox(
            height: 60,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.valueCategories.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildColorIndicator(
                        entry.value[2] as Color,
                        entry.key
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorIndicator(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}