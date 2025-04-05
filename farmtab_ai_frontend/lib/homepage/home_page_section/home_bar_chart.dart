import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

import '../../models/farm_site.dart';

// Define the measurement types
enum MeasurementType {
  ph,
  ec,
  temperature,
  orp,
}

class HomeBarChart extends StatefulWidget {
  final Farm? selectedFarm;
  final int touchedIndex;
  final Function(int) onBarTouched;
  final MeasurementType measurementType;
  final Function(MeasurementType) onMeasurementChanged;
  final Map<String, dynamic> averageData;
  final bool isLoading;

  const HomeBarChart({
    required this.selectedFarm,
    required this.touchedIndex,
    required this.onBarTouched,
    required this.measurementType,
    required this.onMeasurementChanged,
    required this.averageData,
    required this.isLoading,
  });

  @override
  State<HomeBarChart> createState() => _HomeBarChartState();
}

class _HomeBarChartState extends State<HomeBarChart> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final String farmName = widget.selectedFarm?.title ?? 'No farm selected';

    return Container(
      height: media.width * 0.7,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.tune, color: Colors.transparent),
                onPressed: null,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    farmName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: TColor.primaryColor1,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune),
                tooltip: 'Measurement',
                onPressed: () {
                  _showMeasurementSelector(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: widget.isLoading
                ? Center(child: CircularProgressIndicator(color: TColor.primaryColor1,))
                : widget.selectedFarm == null
                ? Center(child: Text('No data available'))
                : BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                    tooltipMargin: 10,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      // String weekDay = _getWeekday(group.x);
                      final sortedDates = widget.averageData.keys.toList()..sort();
                      String selectedDate = sortedDates[group.x];
                      return BarTooltipItem(
                        '$selectedDate\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: (rod.toY - 1).toStringAsFixed(2) + _getMeasurementUnit(),
                            style: TextStyle(
                              color: TColor.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        barTouchResponse == null ||
                        barTouchResponse.spot == null) {
                      widget.onBarTouched(-1);
                    } else {
                      widget.onBarTouched(barTouchResponse.spot!.touchedBarGroupIndex);
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: _getBottomTitles,
                      reservedSize: 38,
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _showingGroups(widget.touchedIndex),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
          // Current measurement type indicator
          Text(
            _getMeasurementLabel(),
            style: TextStyle(
              color: TColor.primaryColor1.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: "Inter",
            ),
          ),
        ],
      ),
    );
  }

  // Show a measurement selection dialog
  void _showMeasurementSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Sensor Value',
            style: TextStyle(
              color: TColor.primaryColor1,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMeasurementOption(context, MeasurementType.ph, 'pH'),
              _buildMeasurementOption(context, MeasurementType.ec, 'EC'),
              _buildMeasurementOption(context, MeasurementType.temperature, 'Temperature'),
              _buildMeasurementOption(context, MeasurementType.orp, 'ORP'),
            ],
          ),
        );
      },
    );
  }

  // Build a single measurement option for the dialog
  Widget _buildMeasurementOption(BuildContext context, MeasurementType type, String label) {
    return ListTile(
      title: Text(label),
      leading: Radio<MeasurementType>(
        value: type,
        groupValue: widget.measurementType,
        onChanged: (MeasurementType? value) {
          if (value != null) {
            widget.onMeasurementChanged(value);
            Navigator.of(context).pop();
          }
        },
        activeColor: TColor.primaryColor1,
      ),
      onTap: () {
        widget.onMeasurementChanged(type);
        Navigator.of(context).pop();
      },
    );
  }

  // Get appropriate label for current measurement type
  String _getMeasurementLabel() {
    switch (widget.measurementType) {
      case MeasurementType.ph:
        return 'pH Level';
      case MeasurementType.ec:
        return 'Electrical Conductivity';
      case MeasurementType.temperature:
        return 'Temperature';
      case MeasurementType.orp:
        return 'Oxidation-Reduction Potential';
    }
  }

  // Get appropriate unit for current measurement type
  String _getMeasurementUnit() {
    switch (widget.measurementType) {
      case MeasurementType.ph:
        return '';  // pH is unitless
      case MeasurementType.ec:
        return ' µS/cm';
      case MeasurementType.temperature:
        return ' °C';
      case MeasurementType.orp:
        return ' mV';
    }
  }

  List<double> _getMeasurementData() {
    final sortedDates = widget.averageData.keys.toList()..sort();

    return sortedDates.map((date) {
      final dayData = widget.averageData[date];

      double value;
      switch (widget.measurementType) {
        case MeasurementType.ph:
          value = (dayData['ph'] ?? 0).toDouble();
          break;
        case MeasurementType.ec:
          value = ((dayData['ec'] ?? 0).toDouble()); // µS/cm to mS/cm
          break;
        case MeasurementType.temperature:
          value = (dayData['temp'] ?? 0).toDouble();
          break;
        case MeasurementType.orp:
          value = (dayData['orp'] ?? 0).toDouble();
          break;
      }

      return value;
    }).toList();
  }

  List<BarChartGroupData> _showingGroups(int touchedIndex) => List.generate(7, (i) {
    final yValues = _getMeasurementData();
    final gradients = [
      TColor.primaryG,
      TColor.secondaryG,
      TColor.primaryG,
      TColor.secondaryG,
      TColor.primaryG,
      TColor.secondaryG,
      TColor.primaryG,
    ];
    return _makeGroupData(i, yValues[i], gradients[i], isTouched: i == touchedIndex);
  });

  BarChartGroupData _makeGroupData(
      int x,
      double y,
      List<Color> barColor, {
        bool isTouched = false,
        double width = 22,
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          gradient: LinearGradient(colors: barColor, begin: Alignment.topCenter, end: Alignment.bottomCenter),
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Colors.green)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: _getMaxYValue(),
            color: TColor.lightGray,
          ),
        ),
      ],
      showingTooltipIndicators: isTouched ? [0] : [],
    );
  }

  // Set appropriate max Y value for the background based on measurement type
  double _getMaxYValue() {
    switch (widget.measurementType) {
      case MeasurementType.ph:
        return 14.0;  // pH scale is 0-14
      case MeasurementType.ec:
        return 300.0;   // Typical EC range for farming
      case MeasurementType.temperature:
        return 40.0;  // Reasonable temperature range
      case MeasurementType.orp:
        return 800.0; // Typical ORP range
    }
  }

  String _getWeekday(int index) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[index % 7];
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    final sortedDates = widget.averageData.keys.toList()..sort();

    String label = '';
    if (value.toInt() < sortedDates.length) {
      final date = sortedDates[value.toInt()];
      label = date.substring(5); // Show MM-DD instead of full YYYY-MM-DD
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(
        label,
        style: TextStyle(
          color: TColor.primaryColor1.withOpacity(0.6),
          fontWeight: FontWeight.w500,
          fontSize: 12,
          fontFamily: "Inter",
        ),
      ),
    );
  }
}