import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/device_service.dart';
import '../theme/color_extension.dart';

class OptimalRangeSettingsPage extends StatefulWidget {
  final int shelfId;
  const OptimalRangeSettingsPage({Key? key, required this.shelfId}) : super(key: key);

  @override
  _OptimalRangeSettingsPageState createState() => _OptimalRangeSettingsPageState();
}

class _OptimalRangeSettingsPageState extends State<OptimalRangeSettingsPage> {
  bool _settingsNotFound = false;
  // pH Range (typically 0-14)
  RangeValues _phRange = const RangeValues(6.0, 7.5);
  final TextEditingController _phMinController = TextEditingController(text: '6.0');
  final TextEditingController _phMaxController = TextEditingController(text: '7.5');

  // EC Range (μS/cm)
  RangeValues _ecRange = const RangeValues(50, 120);
  final TextEditingController _ecMinController = TextEditingController(text: '50');
  final TextEditingController _ecMaxController = TextEditingController(text: '120');

  // Temperature Range (°C)
  RangeValues _tempRange = const RangeValues(20, 25);
  final TextEditingController _tempMinController = TextEditingController(text: '20');
  final TextEditingController _tempMaxController = TextEditingController(text: '25');

  // ORP Range (mV)
  RangeValues _orpRange = const RangeValues(10, 100);
  final TextEditingController _orpMinController = TextEditingController(text: '10');
  final TextEditingController _orpMaxController = TextEditingController(text: '100');

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentSettings();
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

        if (!hasNullValues) {
          _phRange = RangeValues(
            (settings['min_ph'] as num).toDouble(),
            (settings['max_ph'] as num).toDouble(),
          );
          _ecRange = RangeValues(
            (settings['min_ec'] as num).toDouble(),
            (settings['max_ec'] as num).toDouble(),
          );
          _tempRange = RangeValues(
            (settings['min_temperature'] as num).toDouble(),
            (settings['max_temperature'] as num).toDouble(),
          );
          _orpRange = RangeValues(
            (settings['min_orp'] as num).toDouble(),
            (settings['max_orp'] as num).toDouble(),
          );

          _phMinController.text = _phRange.start.toStringAsFixed(1);
          _phMaxController.text = _phRange.end.toStringAsFixed(1);
          _ecMinController.text = _ecRange.start.toStringAsFixed(1);
          _ecMaxController.text = _ecRange.end.toStringAsFixed(1);
          _tempMinController.text = _tempRange.start.toStringAsFixed(1);
          _tempMaxController.text = _tempRange.end.toStringAsFixed(1);
          _orpMinController.text = _orpRange.start.toStringAsFixed(1);
          _orpMaxController.text = _orpRange.end.toStringAsFixed(1);
        }
      });
    } catch (e) {
      print("Failed to fetch settings: $e");
      setState(() {
        _settingsNotFound = true;
      });
    }
  }

  @override
  void dispose() {
    _phMinController.dispose();
    _phMaxController.dispose();
    _ecMinController.dispose();
    _ecMaxController.dispose();
    _tempMinController.dispose();
    _tempMaxController.dispose();
    _orpMinController.dispose();
    _orpMaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TColor.primaryColor1.withOpacity(0.1),
              Colors.white,
            ],
            stops: const [0.0, 0.8],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 35.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header section
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: TColor.primaryColor1,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: TColor.primaryColor1.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Optimal Range Settings',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: TColor.primaryColor1,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Set parameter ranges for optimal growth',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (_settingsNotFound)
                    Padding(
                      padding: const EdgeInsets.only( bottom: 20),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(10),
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
                    ),

                  // pH Range Card
                  _buildParameterCard(
                    title: "pH Value",
                    description: "Acidic to Alkaline scale",
                    icon: Icons.water_drop_outlined,
                    minController: _phMinController,
                    maxController: _phMaxController,
                    onTextChanged: () {
                      final min = double.tryParse(_phMinController.text) ?? _phRange.start;
                      final max = double.tryParse(_phMaxController.text) ?? _phRange.end;
                      if (min <= max && min >= 0 && max <= 14) {
                        setState(() {
                          _phRange = RangeValues(min, max);
                        });
                      }
                    },
                    labelSuffix: "",
                  ),

                  const SizedBox(height: 10),

                  // EC Range Card
                  _buildParameterCard(
                    title: "EC Value",
                    description: "Electrical conductivity range",
                    icon: Icons.electric_bolt_outlined,
                    minController: _ecMinController,
                    maxController: _ecMaxController,
                    onTextChanged: () {
                      final min = double.tryParse(_ecMinController.text) ?? _ecRange.start;
                      final max = double.tryParse(_ecMaxController.text) ?? _ecRange.end;
                      if (min <= max && min >= 0 && max <= 5000) {
                        setState(() {
                          _ecRange = RangeValues(min, max);
                        });
                      }
                    },
                    labelSuffix: " μS/cm",
                  ),
                  const SizedBox(height: 10),
                  // Temperature Range Card
                  _buildParameterCard(
                    title: "Temperature",
                    description: "Optimal temperature range",
                    icon: Icons.thermostat_outlined,
                    minController: _tempMinController,
                    maxController: _tempMaxController,
                    onTextChanged: () {
                      final min = double.tryParse(_tempMinController.text) ?? _tempRange.start;
                      final max = double.tryParse(_tempMaxController.text) ?? _tempRange.end;
                      if (min <= max && min >= 0 && max <= 40) {
                        setState(() {
                          _tempRange = RangeValues(min, max);
                        });
                      }
                    },
                    labelSuffix: " °C",
                  ),
                  const SizedBox(height: 10),
                  // ORP Range Card
                  _buildParameterCard(
                    title: "ORP Value",
                    description: "Oxidation-Reduction Potential ...",
                    icon: Icons.sync_alt_outlined,
                    minController: _orpMinController,
                    maxController: _orpMaxController,
                    onTextChanged: () {
                      final min = double.tryParse(_orpMinController.text) ?? _orpRange.start;
                      final max = double.tryParse(_orpMaxController.text) ?? _orpRange.end;
                      if (min <= max && min >= -500 && max <= 1000) {
                        setState(() {
                          _orpRange = RangeValues(min, max);
                        });
                      }
                    },
                    labelSuffix: " mV",
                  ),

                  const SizedBox(height: 30),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.primaryColor1,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: TColor.primaryColor1.withOpacity(0.5),
                        elevation: 8,
                        shadowColor: TColor.primaryColor1.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isSaving
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'SAVING...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.save_alt,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'SAVE SETTINGS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParameterCard({
    required String title,
    required String description,
    required IconData icon,
    required TextEditingController minController,
    required TextEditingController maxController,
    required VoidCallback onTextChanged,
    required String labelSuffix,
  }) {
    return Card(
      elevation: 12,
      shadowColor: TColor.primaryColor1.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: TColor.primaryColor1.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: TColor.primaryColor1,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TColor.primaryColor1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Min and Max inputs only
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Minimum",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: minController,
                        onChanged: (value) {
                          onTextChanged();
                        },
                        suffix: labelSuffix,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Maximum",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: maxController,
                        onChanged: (value) {
                          onTextChanged();
                        },
                        suffix: labelSuffix,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInputField({
    required TextEditingController controller,
    required Function(String) onChanged,
    required String suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: TColor.primaryColor1.withOpacity(0.05),
        border: Border.all(color: TColor.primaryColor1.withOpacity(0.2), width: 1),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\-?\d*\.?\d*')),
        ],
        style: TextStyle(
          color: TColor.primaryColor1,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: InputBorder.none,
          suffixText: suffix,
          suffixStyle: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _saveSettings() async {
    setState(() {
      _isSaving = true;
    });

    try {
      bool success = await DeviceService.updateDeviceSettings(
        shelfId: widget.shelfId,
        minPh: _phRange.start,
        maxPh: _phRange.end,
        minEc: _ecRange.start,
        maxEc: _ecRange.end,
        minTemp: _tempRange.start,
        maxTemp: _tempRange.end,
        minOrp: _orpRange.start,
        maxOrp: _orpRange.end,
      );

      setState(() {
        _isSaving = false;
      });

      if (success && mounted) {
        Fluttertoast.showToast(
            msg: "Settings saved successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      Fluttertoast.showToast(
          msg: "Failed to save settings!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      print('Error saving settings: $e');
    }
  }
}