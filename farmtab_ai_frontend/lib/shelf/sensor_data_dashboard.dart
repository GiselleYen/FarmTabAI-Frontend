import "dart:async";

import "package:farmtab_ai_frontend/nav tab/home_tab_view.dart";
import "package:farmtab_ai_frontend/shelf/sensor_graph_tab.dart";
import "package:flutter/material.dart";
import "package:farmtab_ai_frontend/theme/color_extension.dart";
import "package:fluttertoast/fluttertoast.dart";

import "../models/sensor_data.dart";
import "../services/device_service.dart";
import "../services/pinned_shelf_service.dart";
import "../services/sensor_services.dart";
import "dashboard_view.dart";

class SensorDataDashboard extends StatefulWidget {
  final int shelfId;
  final String shelfName;

  const SensorDataDashboard({super.key, required this.shelfId, required this.shelfName});

  @override
  State<SensorDataDashboard> createState() => _SensorDataStateDashbaord();
}

class _SensorDataStateDashbaord extends State<SensorDataDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final sensorService = SensorService();
  SensorData? _sensorData;
  SensorData? _previousSensorData;
  bool _settingsNotFound = false;

  late Timer _timer;
  bool _isLoading = true;
  bool isPinned = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData(showLoader: true);
    _timer = Timer.periodic(Duration(seconds: 5), (timer) => _fetchData());
    _fetchCurrentSettings();
    _fetchPinnedState();
  }

  Future<void> _fetchCurrentSettings() async {
    try {
      final settings = await DeviceService.getDeviceSettings(widget.shelfId);

      bool hasNullValues = [
        settings['min_ph'], settings['max_ph'],
        settings['min_ec'], settings['max_ec'],
        settings['min_temperature'], settings['max_temperature'],
        settings['min_orp'], settings['max_orp'],
      ].any((element) => element == null);

      setState(() {
        _settingsNotFound = hasNullValues;
      });
    } catch (e) {
      print("Failed to fetch settings: $e");
      setState(() {
        _settingsNotFound = true;
      });
    }
  }

  void _fetchPinnedState() async {
    final pinnedList = await PinnedShelfService().getPinnedShelves();
    final isCurrentlyPinned = pinnedList.any((shelf) => shelf['shelf_id'] == widget.shelfId);

    setState(() {
      isPinned = isCurrentlyPinned;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchData({bool showLoader = false}) async {
    if (showLoader) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final data = await sensorService.fetchLatestSensorData(widget.shelfId);
      final newSensorData = SensorData.fromJson(data);

      setState(() {
        _previousSensorData = _sensorData;
        _sensorData = newSensorData;
        _isLoading = false;
      });
    } catch (e) {
      if (showLoader) {
        setState(() {
          _error = 'Failed to load data: $e';
          _isLoading = false;
        });
      }
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
            widget.shelfName,
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
            padding: EdgeInsets.only(right: 4),
            child: TextButton.icon(
              onPressed: () async {
                bool success;
                if (isPinned) {
                  success = await PinnedShelfService().unpinShelf(widget.shelfId);
                } else {
                  success = await PinnedShelfService().pinShelf(widget.shelfId);
                }

                if (success) {
                  setState(() => isPinned = !isPinned);
                  Fluttertoast.showToast(
                    msg: isPinned ? "📌 Shelf pinned successfully" : "❌ Shelf unpinned",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: TColor.primaryColor1,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "⚠️ Something went wrong",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              icon: Icon(
                isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                isPinned ? 'Unpin' : 'Pin',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined),
                  SizedBox(width: 4),
                  Text('Monitor'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart),
                  SizedBox(width: 4),
                  Text('Trends'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // First tab content - Dashboard
          RefreshIndicator(
            onRefresh: () => _fetchData(showLoader: true),
            color: TColor.primaryColor1,
            backgroundColor: Colors.white,
            child: _isLoading
                ? _buildLoadingView()
                : _error != null
                ? _buildErrorView()
                : DashboardView(
              sensorData: _sensorData,
              previousSensorData: _previousSensorData,
              onRefresh: _fetchData,
              shelfId: widget.shelfId,
              currentSetting: _settingsNotFound,
            ),
          ),

          // Second tab content
          SensorGraphsTab(shelfId: widget.shelfId, currentSetting: _settingsNotFound,),
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