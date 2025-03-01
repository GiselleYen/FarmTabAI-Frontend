import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../theme/color_extension.dart';
import '../widget/custome_input_decoration.dart';
import '../widget_shelf/sensor_data_card.dart';
import '../widget_shelf/sensor_data_item.dart';

class DashboardView extends StatelessWidget {
  final SensorData? sensorData;
  final VoidCallback onRefresh;

  const DashboardView({
    Key? key,
    required this.sensorData,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    // Left side - Pie Chart with Target Days Button
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator(
                                    value: 7 / 30,
                                    strokeWidth: 12,
                                    backgroundColor: Colors.grey[200],
                                    color: TColor.primaryColor1,
                                  ),
                                ),
                                Text(
                                  '7/30\nDays',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: TColor.primaryColor1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                _showSetDaysDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TColor.primaryColor1,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                minimumSize: Size(120, 32),
                              ),
                              child: Text(
                                'Set Days',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Vertical Divider
                    Container(
                      height: 160,
                      width: 1,
                      color: Colors.grey[300],
                    ),
                    // Right side - Sensor Data
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SensorDataItem(
                                  label: 'pH',
                                  value: sensorData?.ph.toStringAsFixed(2) ?? '0.00',
                                  icon: Icons.water_drop,
                                  isIncreasing: true,
                                ),
                                SensorDataItem(
                                  label: 'EC',
                                  value: '0.05',
                                  icon: Icons.electric_bolt,
                                  isIncreasing: false,
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SensorDataItem(
                                  label: 'ORP',
                                  value: '3.90',
                                  icon: Icons.grain,
                                  isIncreasing: true,
                                ),
                                SensorDataItem(
                                  label: 'TDS',
                                  value: '2.07',
                                  icon: Icons.opacity,
                                  isIncreasing: false,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Last Update: \n${sensorData?.timestamp ?? "N/A"}',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Reset Button (Bottom Right Corner)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: IconButton(
                    icon: Icon(Icons.refresh, color: TColor.primaryColor1, size: 24),
                    onPressed: () {
                      _showResetConfirmDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Spacing
          SizedBox(height: 20),

          // Grid of sensor cards
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.90,
            children: [
              SensorCard(
                icon: Icons.water_drop,
                label: 'pH',
                value: sensorData?.ph.toStringAsFixed(2) ?? '0.00',
                status: sensorData?.phStatusText ?? 'No Data',
                statusColor: sensorData != null
                    ? ColorUtils.getColorFromString(sensorData!.phStatusColor)
                    : Colors.grey,
              ),
              SensorCard(
                icon: Icons.electric_bolt,
                label: 'EC',
                value: sensorData?.ec.toStringAsFixed(2) ?? '0.00',
                status: sensorData?.ecStatusText ?? 'No Data',
                statusColor: Colors.grey,
              ),
              SensorCard(
                icon: Icons.opacity,
                label: 'Temperature',
                value: '27°C',
                status: 'Normal',
                statusColor: Colors.green,
              ),
              SensorCard(
                icon: Icons.grain,
                label: 'ORP',
                value: '650',
                status: 'Too High',
                statusColor: Colors.red,
              ),
              SensorCard(
                icon: Icons.opacity,
                label: 'TDS',
                value: '500',
                status: 'Normal',
                statusColor: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSetDaysDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int targetDays = 30; // Default value
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Set Days',
            style: TextStyle(
              color: TColor.primaryColor1,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How many days until harvest?',
                style: TextStyle(
                  color: TColor.primaryColor1,
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: CustomInputDecoration.build(
                    label: 'Harvest Days'),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    targetDays =
                        int.tryParse(value) ?? 30;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: TColor.primaryColor1,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(targetDays);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primaryColor1,
                padding: EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null) {
        // Handle the set target days here
      }
    });
  }

  void _showResetConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Confirm Reset',
            style: TextStyle(
              color: TColor.primaryColor1,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
            ),
          ),
          content: Text(
            'Are you sure you want to reset all data?',
            style: TextStyle(
              fontFamily: "Poppins",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: TColor.primaryColor1,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Reset values and call the onRefresh callback
                onRefresh();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primaryColor1,
                padding: EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Reset',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}