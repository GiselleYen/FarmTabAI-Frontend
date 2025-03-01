import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../theme/color_extension.dart';

class AddFarmModal extends StatefulWidget {
  final Function(String name, String description, File? image) onSave;
  final String? initialName;
  final String? initialDescription;
  final String? initialImagePath;

  const AddFarmModal({
    Key? key,
    required this.onSave,
    this.initialName,
    this.initialDescription,
    this.initialImagePath,
  }) : super(key: key);

  @override
  _AddFarmModalState createState() => _AddFarmModalState();
}

class _AddFarmModalState extends State<AddFarmModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
    if (widget.initialImagePath != null) {
      _selectedImage = File(widget.initialImagePath!);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.initialName != null ? 'Edit Farm' : 'Add New Farm',
              style: TextStyle(
                color: TColor.primaryColor1,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 130,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, size: 40),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              cursorColor: TColor.primaryColor1.withOpacity(0.7),
              controller: _nameController,
              decoration: InputDecoration(
                label: Text(
                  'Farm Name',
                  style: TextStyle(
                    color: TColor.primaryColor1,
                    fontFamily: 'Poppins',
                  ),
                ),
                hintText: 'Enter Farm Name',
                hintStyle: TextStyle(
                  color: TColor.gray,
                  fontFamily: 'Poppins',
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: TColor.primaryColor1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: TColor.primaryColor1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: TColor.primaryColor1,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter farm name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              cursorColor: TColor.primaryColor1.withOpacity(0.7),
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                label: Text(
                  'Description',
                  style: TextStyle(
                    color: TColor.primaryColor1,
                    fontFamily: 'Poppins',
                  ),
                ),
                hintText: 'Enter Description',
                hintStyle: TextStyle(
                  color: TColor.gray,
                  fontFamily: 'Poppins',
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: TColor.primaryColor1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: TColor.primaryColor1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: TColor.primaryColor1,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: TColor.primaryColor1,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSave(
                        _nameController.text,
                        _descriptionController.text,
                        _selectedImage,
                      );
                      Navigator.pop(context);
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
                    widget.initialName != null ? 'Update' : 'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}