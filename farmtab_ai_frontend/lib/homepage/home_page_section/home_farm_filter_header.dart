import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/farm_site.dart';
import '../../services/farmSite_service.dart';

class HomeFarmFilterHeader extends StatefulWidget {
  final Farm selectedFarm;
  final void Function(Farm) onFarmSelected;

  const HomeFarmFilterHeader({
    super.key,
    required this.selectedFarm,
    required this.onFarmSelected,
  });

  @override
  _HomeFarmFilterHeaderState createState() => _HomeFarmFilterHeaderState();
}

class _HomeFarmFilterHeaderState extends State<HomeFarmFilterHeader> {
  List<Farm> farms = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchFarms();
  }

  Future<void> _fetchFarms() async {
    try {
      final fetchedFarms = await FarmService().getFarms();
      setState(() {
        farms = fetchedFarms;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load farms: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: TColor.primaryColor1,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(width: 8),
            Text(
              "Daily Crop Condition",
              style: TextStyle(
                color: TColor.primaryColor1,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms),
        IconButton(
          icon: Icon(Icons.filter_list, color: TColor.primaryColor1),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                Farm? tempSelection = widget.selectedFarm;

                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      contentPadding: EdgeInsets.zero,
                      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Select Farm',
                                style: TextStyle(
                                  color: TColor.primaryColor1,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins",
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.close, color: TColor.primaryColor1.withOpacity(0.7), size: 20),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: TColor.lightGray,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                      content: Container(
                        width: double.maxFinite,
                        constraints: const BoxConstraints(maxHeight: 300),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: isLoading
                            ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1),
                          ),
                        )
                            : errorMessage.isNotEmpty
                            ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline, color: Colors.red, size: 32),
                              const SizedBox(height: 12),
                              Text(
                                errorMessage,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontFamily: "Inter",
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                            : farms.isEmpty
                            ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.agriculture, color: Colors.black26, size: 32),
                              const SizedBox(height: 12),
                              Text(
                                "No farms found",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: "Inter",
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                            : ListView.builder(
                          itemCount: farms.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final farm = farms[index];
                            return RadioListTile<Farm>(
                              title: Text(
                                farm.title,
                                style: const TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              value: farm,
                              groupValue: tempSelection,
                              onChanged: (value) {
                                setState(() {
                                  tempSelection = value!;
                                });
                              },
                              activeColor: TColor.primaryColor1,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              dense: true,
                              selected: tempSelection == farm,
                              selectedTileColor: TColor.primaryColor1.withOpacity(0.05),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          },
                        ),
                      ),
                      actions: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: TColor.primaryColor1.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: tempSelection == null
                                    ? null
                                    : () {
                                  Navigator.pop(context);
                                  widget.onFarmSelected(tempSelection!);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                                    if (states.contains(MaterialState.disabled)) {
                                      return Colors.grey.shade300;
                                    }
                                    return TColor.primaryColor1;
                                  }),
                                  foregroundColor: MaterialStateProperty.all(Colors.white),
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Apply',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      // Remove actionsPadding since we're handling it in the container
                      actionsPadding: EdgeInsets.zero,
                    );
                  },
                );
              },
            );
          },
        ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
      ],
    );
  }
}