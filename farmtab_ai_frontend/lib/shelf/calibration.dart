// import 'package:flutter/material.dart';
//
// import '../services/sensor_services.dart';
// import '../theme/color_extension.dart';
//
// class CalibrationPage extends StatefulWidget {
//   const CalibrationPage({Key? key}) : super(key: key);
//
//   @override
//   _CalibrationPageState createState() => _CalibrationPageState();
// }
//
// class _CalibrationPageState extends State<CalibrationPage> {
//   final sensorService = SensorService();
//
//   double currentPh = 0.0;
//   double currentEc = 0.0;
//
//   // Controllers for the text fields
//   final TextEditingController phController = TextEditingController();
//   final TextEditingController ecController = TextEditingController();
//
//   // Status messages
//   String phStatus = '';
//   String ecStatus = '';
//
//   // Loading state
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchLatestSensorData();
//   }
//
//   Future<void> fetchLatestSensorData() async {
//     try {
//       final sensorData = await sensorService.fetchLatestSensorData();
//
//       setState(() {
//         currentPh = sensorData['ph'] ?? 0.0;
//         currentEc = sensorData['ec'] ?? 0.0;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         var errorMessage = 'Error: ${e.toString()}';
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     phController.dispose();
//     ecController.dispose();
//     super.dispose();
//   }
//
//   Future<void> sendCalibrationData(String sensorType, double value) async {
//     try {
//       setState(() {
//         if (sensorType == 'ph') {
//           phStatus = 'Sending calibration data...';
//         } else {
//           ecStatus = 'Sending calibration data...';
//         }
//       });
//
//       final sensorService = SensorService();
//       final success = await sensorService.sendCalibrationData(
//         sensorType: sensorType,
//         value: value,
//       );
//
//       if (success) {
//         setState(() {
//           if (sensorType == 'ph') {
//             phStatus = 'Calibrated pH to ${value.toStringAsFixed(2)} ✓';
//             currentPh = value;
//           } else {
//             ecStatus = 'Calibrated EC to ${value.toStringAsFixed(1)} μS/cm ✓';
//             currentEc = value;
//           }
//         });
//       }
//     } catch (e) {
//       setState(() {
//         if (sensorType == 'ph') {
//           phStatus = 'Error: Could not send calibration data. ${e.toString()}';
//         } else {
//           ecStatus = 'Error: Could not send calibration data. ${e.toString()}';
//         }
//       });
//     }
//   }
//
//   void calibratePh() {
//     if (phController.text.isEmpty) {
//       setState(() {
//         phStatus = 'Please enter a valid pH value';
//       });
//       return;
//     }
//
//     try {
//       double newValue = double.parse(phController.text);
//       if (newValue < 0 || newValue > 14) {
//         setState(() {
//           phStatus = 'pH must be between 0 and 14';
//         });
//         return;
//       }
//
//       // Send to backend
//       sendCalibrationData('ph', newValue);
//       phController.clear();
//     } catch (e) {
//       setState(() {
//         phStatus = 'Invalid pH value';
//       });
//     }
//   }
//
//   void calibrateEc() {
//     if (ecController.text.isEmpty) {
//       setState(() {
//         ecStatus = 'Please enter a valid EC value';
//       });
//       return;
//     }
//
//     try {
//       double newValue = double.parse(ecController.text);
//       if (newValue < 0) {
//         setState(() {
//           ecStatus = 'EC cannot be negative';
//         });
//         return;
//       }
//
//       // Send to backend
//       sendCalibrationData('ec', newValue);
//       ecController.clear();
//     } catch (e) {
//       setState(() {
//         ecStatus = 'Invalid EC value';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isLoading
//           ? Center(
//         child: CircularProgressIndicator(
//           color: TColor.primaryColor1,
//         ),
//       )
//           : Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               TColor.primaryColor1.withOpacity(0.1),
//               Colors.white,
//             ],
//             stops: const [0.0, 0.8],
//           ),
//         ),
//         child: SafeArea(
//           child: RefreshIndicator(
//             onRefresh: fetchLatestSensorData,
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(
//                 parent: AlwaysScrollableScrollPhysics(),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24.0,
//                   vertical: 35.0,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // App title and logo
//                     Center(
//                       child: Column(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: TColor.primaryColor1,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: TColor.primaryColor1.withOpacity(0.4),
//                                   blurRadius: 20,
//                                   spreadRadius: 2,
//                                 ),
//                               ],
//                             ),
//                             child: const Icon(
//                               Icons.science,
//                               size: 48,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           Text(
//                             'Device Calibration',
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: TColor.primaryColor1,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Calibrate your sensors',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 40),
//
//                     // pH Calibration Section
//                     _buildCalibrationCard(
//                       icon: Icons.opacity,
//                       title: 'pH Calibration',
//                       currentValue: currentPh.toStringAsFixed(2),
//                       unit: 'pH',
//                       controller: phController,
//                       hintText: 'Enter new pH value',
//                       buttonText: 'Calibrate pH',
//                       onPressed: calibratePh,
//                       statusMessage: phStatus,
//                     ),
//
//                     const SizedBox(height: 24),
//
//                     // EC Calibration Section
//                     _buildCalibrationCard(
//                       icon: Icons.flash_on,
//                       title: 'EC Calibration',
//                       currentValue: currentEc.toStringAsFixed(1),
//                       unit: 'μS/cm',
//                       controller: ecController,
//                       hintText: 'Enter new EC value',
//                       buttonText: 'Calibrate EC',
//                       onPressed: calibrateEc,
//                       statusMessage: ecStatus,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCalibrationCard({
//     required IconData icon,
//     required String title,
//     required String currentValue,
//     required String unit,
//     required TextEditingController controller,
//     required String hintText,
//     required String buttonText,
//     required VoidCallback onPressed,
//     required String statusMessage,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: TColor.primaryColor1.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: TColor.primaryColor1,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//
//           // Current Reading Section
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: TColor.primaryColor1.withOpacity(0.06),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Current Reading',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey.shade700,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       currentValue,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: TColor.primaryColor1,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       unit,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey.shade700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 24),
//
//           // Input Field
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.grey.shade50,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: TextField(
//               controller: controller,
//               keyboardType: const TextInputType.numberWithOptions(decimal: true),
//               decoration: InputDecoration(
//                 hintText: hintText,
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.all(16),
//                 hintStyle: TextStyle(color: Colors.grey.shade500),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 24),
//
//           // Button
//           SizedBox(
//             width: double.infinity,
//             height: 56,
//             child: ElevatedButton(
//               onPressed: onPressed,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: TColor.primaryColor1,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 0,
//               ),
//               child: Text(
//                 buttonText,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//
//           // Status Message
//           if (statusMessage.isNotEmpty) ...[
//             const SizedBox(height: 16),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//               decoration: BoxDecoration(
//                 color: statusMessage.contains('Invalid') || statusMessage.contains('must be')
//                     ? Colors.red.shade50
//                     : Colors.green.shade50,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 statusMessage,
//                 style: TextStyle(
//                   color: statusMessage.contains('Invalid') || statusMessage.contains('must be')
//                       ? Colors.red.shade700
//                       : Colors.green.shade700,
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
