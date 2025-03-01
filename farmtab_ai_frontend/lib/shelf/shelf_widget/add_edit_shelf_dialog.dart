import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class ShelfDialogData {
  final String title;
  final String subtitle;
  final String imagePath;

  ShelfDialogData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
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

  @override
  void initState() {
    super.initState();
    shelfName = widget.initialData?.title ?? "";
    shelfSubtitle = widget.initialData?.subtitle ?? "";
    selectedImagePath = widget.initialData?.imagePath;
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
        child: selectedImagePath!.startsWith('assets/')
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