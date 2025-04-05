import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/shelf.dart';
import '../nav tab/shelf_tab_view.dart';
import '../services/device_service.dart';
import '../theme/color_extension.dart';
import '../widget/custome_input_decoration.dart';

class DeviceRegistrationPage extends StatefulWidget {
  final Shelf shelf;

  const DeviceRegistrationPage({Key? key, required this.shelf}) : super(key: key);

  @override
  State<DeviceRegistrationPage> createState() => _DeviceRegistrationPageState();
}

class _DeviceRegistrationPageState extends State<DeviceRegistrationPage> {
  final TextEditingController _serialController = TextEditingController();
  String? _currentSerial;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkExistingDevice();
  }

  Future<void> _checkExistingDevice() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final deviceData = await DeviceService.getDeviceByShelfId(widget.shelf.id);
      setState(() {
        _currentSerial = deviceData.isNotEmpty ? deviceData['serial_number'] : null;
        print(_currentSerial);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to check existing device: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSerial() async {//
    final serial = _serialController.text.trim();
    if (serial.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid serial number'),
          backgroundColor: TColor.primaryColor1.withOpacity(0.8),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      bool success;
      if (_currentSerial == null) {
        success = await DeviceService.registerDevice(
          serial: serial,
          shelfId: widget.shelf.id,
        );
      } else {
        success = await DeviceService.updateDevice(
          serial: serial,
          shelfId: widget.shelf.id,
        );
      }

      if (success) {
        setState(() {
          _currentSerial = serial;
          _serialController.clear();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Device saved successfully!'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate after a short delay to allow snackbar to show
          await Future.delayed(Duration(milliseconds: 500));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ShelfTabView(shelf: widget.shelf),
            ),
          );
        }
      }

    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save device: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    _serialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: TColor.primaryColor1,
        ),
      )
          : Container(
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
                  // App title and logo
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
                            Icons.devices_other,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Device Registration',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: TColor.primaryColor1,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Connect your device to continue',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Current device serial display
                  Card(
                    elevation: 12,
                    shadowColor: TColor.primaryColor1.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.qr_code_scanner,
                                size: 24,
                                color: TColor.primaryColor1,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Current Device Serial',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: TColor.primaryColor1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: TColor.primaryColor1.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: TColor.primaryColor1.withOpacity(0.2),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _currentSerial == null
                                      ? Icons.error_outline
                                      : Icons.check_circle_outline,
                                  color: _currentSerial == null
                                      ? Colors.orange
                                      : Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _currentSerial ?? '-',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Consolas',
                                    letterSpacing: 1.5,
                                    color: _currentSerial == null
                                        ? Colors.grey.shade600
                                        : TColor.primaryColor1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Input section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentSerial == null ? 'Register Device Serial' : 'Update Device Serial',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TColor.primaryColor1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentSerial == null
                              ? 'Add a serial number for this shelf'
                              : 'Change the serial number for this shelf',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Serial number input field
                        TextFormField(
                          controller: _serialController,
                          cursorColor: TColor.primaryColor1.withOpacity(0.7),
                          decoration: CustomInputDecoration.build(
                              label: 'Device Serial Number'),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9\-]'),
                            ),
                            LengthLimitingTextInputFormatter(24),
                          ],
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _saveSerial(),
                        ),

                        const SizedBox(height: 20),

                        // Save button
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _saveSerial,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TColor.primaryColor1,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                              TColor.primaryColor1.withOpacity(0.5),
                              elevation: 8,
                              shadowColor:
                              TColor.primaryColor1.withOpacity(0.5),
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
                                Text(
                                  _currentSerial == null ? 'REGISTERING...' : 'UPDATING...',
                                  style: const TextStyle(
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
                                Icon(
                                  Icons.save_alt,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _currentSerial == null ? 'REGISTER DEVICE' : 'UPDATE DEVICE',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}