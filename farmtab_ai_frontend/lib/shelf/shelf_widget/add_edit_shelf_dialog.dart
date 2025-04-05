import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class ShelfDialogData {
  final String title;
  final String subtitle;
  final String imagePath;
  final String plantType;
  final int harvestDays;
  final String deviceSerialNumber;

  ShelfDialogData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.plantType,
    required this.harvestDays,
    this.deviceSerialNumber = '',
  });
}


class AddEditShelfDialog extends StatefulWidget {
  final String dialogTitle;
  final ShelfDialogData? initialData;

  const AddEditShelfDialog({
    Key? key,
    required this.dialogTitle,
    this.initialData,
  }) : super(key: key);

  @override
  State<AddEditShelfDialog> createState() => _AddEditShelfDialogState();
}

class _AddEditShelfDialogState extends State<AddEditShelfDialog> {
  late String shelfName;
  late String shelfSubtitle;
  String? selectedImagePath;
  late String plantType;
  late int harvestDays;

  @override
  @override
  void initState() {
    super.initState();
    shelfName = widget.initialData?.title ?? "";
    shelfSubtitle = widget.initialData?.subtitle ?? "";
    selectedImagePath = widget.initialData?.imagePath;
    plantType = widget.initialData?.plantType ?? "";
    harvestDays = widget.initialData?.harvestDays ?? 0;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImagePath = image.path;
      });
    }
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 130,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _buildImageContent(),
      ),
    );
  }

  Widget _buildImageContent() {
    if (selectedImagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: selectedImagePath!.startsWith('http')
            ? Image.network(selectedImagePath!, fit: BoxFit.cover)
            : selectedImagePath!.startsWith('assets/')
            ? Image.asset(selectedImagePath!, fit: BoxFit.cover)
            : Image.file(File(selectedImagePath!), fit: BoxFit.cover),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 40,
          color: TColor.primaryColor1,
        ),
        SizedBox(height: 8),
        Text(
          "Tap to add shelf image",
          style: TextStyle(
            color: TColor.primaryColor1,
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      label: Text(
        label,
        style: TextStyle(
          color: TColor.primaryColor1,
          fontFamily: 'Poppins',
        ),
      ),
      hintText: 'Enter $label',
      hintStyle: TextStyle(
        color: TColor.gray,
        fontFamily: 'Poppins',
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: TColor.primaryColor1),
        borderRadius: BorderRadius.circular(6),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: TColor.primaryColor1),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: TColor.primaryColor1,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildHarvestDaysStepper() {
      final TextEditingController _harvestDaysController =
      TextEditingController(text: '$harvestDays');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Harvest Days',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 16,
              color: TColor.primaryColor1,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: TColor.primaryColor1.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                // Decrease button
                IconButton(
                  icon: Icon(Icons.arrow_drop_down, color: TColor.primaryColor1),
                  onPressed: () {
                    setState(() {
                      if (harvestDays > 0) {
                        harvestDays--;
                        _harvestDaysController.text = '$harvestDays';
                      }
                    });
                  },
                ),

                // Input field
                Expanded(
                  child: TextField(
                    controller: _harvestDaysController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: TColor.primaryColor1,
                    ),
                    onChanged: (value) {
                      setState(() {
                        harvestDays = int.tryParse(value) ?? harvestDays;
                      });
                    },
                  ),
                ),

                // Increase button
                IconButton(
                  icon: Icon(Icons.arrow_drop_up, color: TColor.primaryColor1),
                  onPressed: () {
                    setState(() {
                      harvestDays++;
                      _harvestDaysController.text = '$harvestDays';
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        widget.dialogTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: TColor.primaryColor1,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: "Poppins",
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImagePicker(),
            SizedBox(height: 16),
            TextFormField(
              initialValue: shelfName,
              cursorColor: TColor.primaryColor1.withOpacity(0.7),
              onChanged: (value) => shelfName = value,
              decoration: _buildInputDecoration('Shelf Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter shelf name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: shelfSubtitle,
              cursorColor: TColor.primaryColor1.withOpacity(0.7),
              maxLines: 2,
              onChanged: (value) => shelfSubtitle = value,
              decoration: _buildInputDecoration('Subtitle'),
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: plantType,
              cursorColor: TColor.primaryColor1.withOpacity(0.7),
              onChanged: (value) => plantType = value,
              decoration: _buildInputDecoration('Plant Type'),
            ),
            SizedBox(height: 16),
            _buildHarvestDaysStepper(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: TextStyle(
              color: TColor.primaryColor1,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (shelfName.isNotEmpty) {
              Navigator.pop(
                context,
                ShelfDialogData(
                  title: shelfName,
                  subtitle: shelfSubtitle.isEmpty ? "-" : shelfSubtitle,
                  imagePath: selectedImagePath ?? "assets/images/placeholder.jpg",
                  plantType: plantType,
                  harvestDays: harvestDays,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: TColor.primaryColor1,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            widget.initialData == null ? "Add" : "Save",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
            ),
          ),
        ),
      ],
    );
  }
}


