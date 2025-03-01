import "dart:async";

import "package:farmtab_ai_frontend/nav tab/home_tab_view.dart";
import "package:farmtab_ai_frontend/shelf/sensor_graph_tab.dart";
import "package:flutter/material.dart";
import "package:farmtab_ai_frontend/theme/color_extension.dart";

import "../models/sensor_data.dart";
import "../services/sensor_data_service.dart";
// Import the new dashboard view
import "dashboard_view.dart";

class SensorDataDashboard extends StatefulWidget {
  const SensorDataDashboard({super.key});
  @override
  State<SensorDataDashboard> createState() => _SensorDataStateDashbaord();
}

class _SensorDataStateDashbaord extends State<SensorDataDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SensorDataService _dataService = SensorDataService();
  SensorData? _sensorData;

  late Timer _timer;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _fetchData();
    _timer = Timer.periodic(Duration(seconds: 100), (timer) => _fetchData());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final data = await _dataService.getLatestData();
      setState(() {
        _sensorData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
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
          RefreshIndicator(
            onRefresh: _fetchData,
            color: TColor.primaryColor1,
            backgroundColor: Colors.white,
            child: _isLoading
                ? _buildLoadingView()
                : _error != null
                ? _buildErrorView()
                : DashboardView(
              sensorData: _sensorData,
              onRefresh: _fetchData,
            ),
          ),

          // Second tab content
          SensorGraphsTab(),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: TColor.primaryColor1,
          ),
          SizedBox(height: 20),
          Text(
            'Fetching sensor data...',
            style: TextStyle(
              color: TColor.primaryColor1,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Error Loading Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchData,
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primaryColor1,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Retry',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}