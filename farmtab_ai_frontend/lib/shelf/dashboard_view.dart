import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sensor_data.dart';
import '../models/shelf.dart';
import '../services/shelf_service.dart';
import '../theme/color_extension.dart';
import '../widget/custome_input_decoration.dart';
import '../widget_shelf/sensor_data_card.dart';
import '../widget_shelf/sensor_data_item.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardView extends StatefulWidget {
  final SensorData? sensorData;
  final SensorData? previousSensorData;
  final VoidCallback onRefresh;
  final int shelfId;
  final bool currentSetting;

  const DashboardView({
    Key? key,
    required this.sensorData,
    required this.previousSensorData,
    required this.onRefresh,
    required this.shelfId,
    required this.currentSetting
  }) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  Shelf? shelf;
  bool isLoading = true;
  SensorData? previousSensorData;

  @override
  void initState() {
    super.initState();
    loadShelf();
  }

  Future<void> loadShelf() async {
    try {
      final fetchedShelf = await ShelfService().getShelfById(widget.shelfId);
      setState(() {
        shelf = fetchedShelf;
        isLoading = false;
      });
    } catch (e) {
      print("Failed to load shelf: $e");
      setState(() => isLoading = false);
    }
  }

  TrendDirection getTrend(double? previous, double? current) {
    if (previous == null || current == null) return TrendDirection.equal;
    if (current > previous) return TrendDirection.increase;
    if (current < previous) return TrendDirection.decrease;
    return TrendDirection.equal;
  }

  String getFormattedTime() {
    if (widget.sensorData?.timestamp != null) {
      try {
        DateTime utcTime = DateTime.parse(widget.sensorData!.timestamp!).toUtc();
        DateTime localTime = utcTime.toLocal();
        return DateFormat('MMM dd, yyyy • hh:mm a').format(localTime);
      } catch (e) {
        return "Invalid timestamp";
      }
    }
    return "No data";
  }

  @override
  Widget build(BuildContext context) {
    SensorData? current = widget.sensorData;
    SensorData? previous = widget.previousSensorData;

    return Column(
      children: [
        // Settings Warning Banner
        if (widget.currentSetting)
          _buildSettingsWarning()
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: -0.2, end: 0),

        // Main Content
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              widget.onRefresh();
              await loadShelf();
            },
            color: TColor.primaryColor1,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dashboard Header
                    _buildDashboardHeader()
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: -0.2, end: 0),

                    const SizedBox(height: 10),

                    // Summary Card
                    _buildSummaryCard(current, previous)
                        .animate()
                        .scale(duration: 400.ms, curve: Curves.easeOutBack),

                    Container(
                      margin: const EdgeInsets.only(top: 0),
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          shelf != null && shelf!.passedDays == 0
                              ? ElevatedButton.icon(
                            onPressed: () async {
                              if (widget.currentSetting) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("⚠️ Please set the optimal range before starting the cycle."),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }

                              await ShelfService().updatePassedDays(
                                shelfId: widget.shelfId,
                                passedDays: 1,
                              );

                              await loadShelf(); // Refresh to reflect change
                            },
                            icon: const Icon(Icons.play_arrow, size: 16),
                            label: const Text(
                              'START CYCLE',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              elevation: 3,
                            ),
                          )
                              : ElevatedButton.icon(
                            onPressed: () => _showHarvestConfirmDialog(context),
                            icon: const Icon(Icons.agriculture, size: 16),
                            label: const Text(
                              'HARVEST',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade500,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              elevation: 3,
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 300.ms)
                              .scale(delay: 200.ms),
                        ],
                      ),
                    ),

                    const SizedBox(height: 0),

                    // Detailed Sensor Data Section Title
                    Text(
                      "Detailed Readings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: TColor.primaryColor1,
                      ),
                    ).animate()
                        .fadeIn(duration: 600.ms, delay: 200.ms),
                    const SizedBox(height: 8),

                    _buildSensorCardsGrid().animate()
                        .fadeIn(duration: 600.ms, delay: 300.ms),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsWarning() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red.shade800, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "You haven't set the optimal range yet. Please set and save your settings.",
              style: TextStyle(
                color: Colors.red.shade800,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: TColor.primaryColor1,
          ),
        ),
        Text(
          getFormattedTime(),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(SensorData? current, SensorData? previous) {
    double progressValue = shelf != null ?
    (shelf!.passedDays / shelf!.harvestDays).clamp(0.0, 1.0) : 0.0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TColor.primaryColor1.withOpacity(0.9),
            TColor.primaryColor1,
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(0),
        ),
        boxShadow: [
          BoxShadow(
            color: TColor.primaryColor1.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top section with harvest days indicator
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Progress indicator
                SizedBox(
                  height: 90,
                  width: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background circle
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      // Progress indicator
                      SizedBox(
                        height: 90,
                        width: 90,
                        child: CircularProgressIndicator(
                          value: progressValue,
                          strokeWidth: 10,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          color: Colors.white,
                        ),
                      ),
                      // Text in center
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${shelf != null ? shelf!.passedDays : 0}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'DAYS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Text and button
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Harvest Progress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${shelf != null ? shelf!.passedDays : 0} days passed out of ${shelf != null ? shelf!.harvestDays : 0}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _showSetDaysDialog(context),
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Set Days'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: TColor.primaryColor1,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.white.withOpacity(0.2),
          ),

          // Bottom section with sensor readings
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickSensorItem(
                  Icons.water_drop_outlined,
                  'pH',
                  current?.ph.toStringAsFixed(1) ?? '0.0',
                  getTrend(previous?.ph, current?.ph),
                ),
                _buildQuickSensorItem(
                  Icons.electric_bolt_outlined,
                  'EC',
                  current?.ec.toStringAsFixed(1) ?? '0.0',
                  getTrend(previous?.ec, current?.ec),
                ),
                _buildQuickSensorItem(
                  Icons.thermostat_outlined,
                  'Temp',
                  current?.temp.toStringAsFixed(1) ?? '0.0',
                  getTrend(previous?.temp, current?.temp),
                ),
                _buildQuickSensorItem(
                  Icons.grain_outlined,
                  'ORP',
                  current?.orp.toStringAsFixed(1) ?? '0',
                  getTrend(previous?.orp?.toDouble(), current?.orp?.toDouble()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSensorItem(IconData icon, String label, String value, TrendDirection trend) {
    // Enhanced trend indicators with more obvious visuals
    IconData trendIcon;
    Color trendColor;
    double size = 16; // Increased from 12 to 16

    switch (trend) {
      case TrendDirection.increase:
        trendIcon = Icons.trending_up;  // Changed from arrow_upward
        trendColor = Colors.greenAccent;  // Changed from white to green
        break;
      case TrendDirection.decrease:
        trendIcon = Icons.trending_down;  // Changed from arrow_downward
        trendColor = Colors.redAccent;  // Changed from white to red
        break;
      case TrendDirection.equal:
      default:
        trendIcon = Icons.trending_flat;  // Changed from remove
        trendColor = Colors.white.withOpacity(0.7);
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4),
            // Enhanced trend indicator with background
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: trendColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(trendIcon, color: trendColor, size: size),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSensorCardsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.0,
      children: [
        _buildDetailedSensorCard(
          Icons.water_drop_rounded,
          'pH',
          Text(
            widget.sensorData?.ph?.toStringAsFixed(2) ?? '0.00',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          widget.sensorData?.phStatus?['text'] ?? 'No Data',
          widget.sensorData != null
              ? ColorUtils.getColorFromString(widget.sensorData?.phStatus?['color'] ?? 'grey')
              : Colors.grey,
        ),
        _buildDetailedSensorCard(
          Icons.electric_bolt_rounded,
          'EC',
          RichText(
            text: TextSpan(
              text: '${widget.sensorData?.ec.toString() ?? '0'} ',
              style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
              children: const [
                TextSpan(
                  text: 'µS/cm',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          widget.sensorData?.ecStatus['text'] ?? 'No Data',
          widget.sensorData != null
              ? ColorUtils.getColorFromString(widget.sensorData?.ecStatus['color'])
              : Colors.grey,
        ),
        _buildDetailedSensorCard(
          Icons.thermostat_rounded,
          'Temperature',
          RichText(
            text: TextSpan(
              text: '${widget.sensorData?.temp.toString() ?? '0'} ',
              style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
              children: const [
                TextSpan(
                  text: '°C',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          widget.sensorData?.tempStatus['text'] ?? 'No Data',
          widget.sensorData != null
              ? ColorUtils.getColorFromString(widget.sensorData?.tempStatus['color'])
              : Colors.grey,
        ),
        _buildDetailedSensorCard(
          Icons.grain_rounded,
          'ORP',
          RichText(
            text: TextSpan(
              text: '${widget.sensorData?.orp.toString() ?? '0'} ',
              style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
              children: const [
                TextSpan(
                  text: 'mV',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          widget.sensorData?.orpStatus['text'] ?? 'No Data',
          widget.sensorData != null
              ? ColorUtils.getColorFromString(widget.sensorData?.orpStatus['color'])
              : Colors.grey,
        ),
      ],
    );
  }

  Widget _buildDetailedSensorCard(
      IconData icon,
      String label,
      Widget valueWidget, // changed from String value
      String status,
      Color statusColor,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background colored circle
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor.withOpacity(0.1),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon with circular background
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: statusColor, size: 22),
                ),

                const Spacer(),

                // Value with unit (as RichText)
                valueWidget,

                const SizedBox(height: 4),

                // Label
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 8),

                // Status chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSetDaysDialog(BuildContext context) {
    final TextEditingController daysController = TextEditingController(
      text: shelf?.harvestDays.toString() ?? '',
    );
    final TextEditingController passedDaysController = TextEditingController(
      text: shelf?.passedDays.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Update Days',
            style: TextStyle(
              color: TColor.primaryColor1,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How many days until harvest?',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: daysController,
                keyboardType: TextInputType.number,
                decoration: CustomInputDecoration.build(
                  label: 'Harvest Days',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passedDaysController,
                keyboardType: TextInputType.number,
                decoration: CustomInputDecoration.build(
                  label: 'Passed Days',
                ),
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
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // close dialog first

                final newDays = int.tryParse(daysController.text);
                final newPassedDays = int.tryParse(passedDaysController.text);

                if (newDays == null || newPassedDays == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter valid numbers."),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                if (newPassedDays < 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Passed days must be at least 1."),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                if (newPassedDays > newDays) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Passed days cannot be more than harvest days."),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                try {
                  await ShelfService().updateShelf(
                    shelfId: widget.shelfId,
                    name: shelf!.name,
                    subtitle: shelf!.subtitle,
                    plantType: shelf!.plantType,
                    harvestDays: newDays,
                    imageFile: null,
                    isFavourite: shelf!.isFavourite,
                  );
                  await ShelfService().updatePassedDays(
                    shelfId: widget.shelfId,
                    passedDays: newPassedDays,
                  );
                  await loadShelf(); // Refresh local shelf data
                } catch (e) {
                  print("Update failed: $e");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primaryColor1,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Changed from _showResetConfirmDialog to _showHarvestConfirmDialog
  void _showHarvestConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Confirm Harvest',
            style: TextStyle(
              color: TColor.primaryColor1,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Changed icon to agriculture/harvest icon
              const Icon(
                Icons.agriculture,
                color: Colors.green,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Ready to harvest your plants?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This will reset your passed days counter to zero and mark this growing cycle as complete.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
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
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Same functionality as reset, but with a different UI presentation
                  await ShelfService().resetPassedDays(widget.shelfId);
                  loadShelf(); // refresh the UI
                  Navigator.of(context).pop();
                } catch (e) {
                  print("Harvest process failed: $e");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade500,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Harvest Now',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}