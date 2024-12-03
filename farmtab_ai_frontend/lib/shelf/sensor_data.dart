import "package:farmtab_ai_frontend/nav tab/home_tab_view.dart";
import "package:farmtab_ai_frontend/shelf/sensor_graph_tab.dart";
import "package:flutter/material.dart";
import "package:farmtab_ai_frontend/theme/color_extension.dart";

import "../widget_shelf/sensor_data_card.dart";
import "../widget_shelf/sensor_data_item.dart";

class SensorData extends StatefulWidget {
  const SensorData({super.key});
  @override
  State<SensorData> createState() => _SensorDataState();
}

class _SensorDataState extends State<SensorData> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.backgroundColor1,
      appBar: AppBar(
        backgroundColor: TColor.primaryColor1,
        elevation: 2,
        leadingWidth: 65,
        leading: Padding(
          padding: EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            'Shelf A',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'OpenSans',
              letterSpacing: 0.5,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeTabView()),
                      (route) => false,
                );
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          tabs: [
            Tab(
              icon: Icon(Icons.analytics_outlined),
            ),
            Tab(
              icon: Icon(Icons.show_chart),
            ),
          ],
        ),
      ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // First tab content - Dashboard
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    height: 180,
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
                    child: Row(
                      children: [
                        // Left side - Pie Chart
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Stack(
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
                                      value: '0.03',
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
                                SizedBox(height: 12),
                                Text(
                                  'Last Update: \n2024-11-22 14:30',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
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
                        value: '6.5',
                        status: 'Normal',
                        statusColor: Colors.green,
                      ),
                      SensorCard(
                        icon: Icons.electric_bolt,
                        label: 'EC',
                        value: '1.2',
                        status: 'Too Low',
                        statusColor: Colors.grey,
                      ),
                      SensorCard(
                        icon: Icons.thermostat,
                        label: 'Temperature',
                        value: '25°C',
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
            ),

            // Second tab content
            SensorGraphsTab(),
          ],
        ),
    );
  }
}