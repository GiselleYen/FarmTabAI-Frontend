import 'dart:io';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:image_picker/image_picker.dart';

class AddFarmModal extends StatefulWidget {
  final Function(String, String, XFile?) onSave;
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
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
    _isEditing = widget.initialName != null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        setState(() {
          _image = selectedImage;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Widget _buildImageSection() {
    Widget imageContent;

    if (_image != null) {
      imageContent = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(File(_image!.path), fit: BoxFit.cover),
      );
    } else if (widget.initialImagePath != null && widget.initialImagePath!.isNotEmpty) {
      imageContent = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: widget.initialImagePath!.startsWith('http')
            ? Image.network(
          widget.initialImagePath!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
        )
            : Image.asset(widget.initialImagePath!, fit: BoxFit.cover),
      );
    } else {
      imageContent = _buildPlaceholderImage();
    }

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: imageContent,
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined, size: 40, color: TColor.primaryColor1),
          SizedBox(height: 8),
          Text('Add Site Image', style: TextStyle(color: TColor.primaryColor1, fontFamily: "Poppins")),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, String hint = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: "Poppins"),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey, fontFamily: "Poppins"),
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isEditing ? 'Edit Site' : 'Add New Site',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: TColor.primaryColor1,
                  fontFamily: "Poppins",
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  _buildImageSection(),
                  SizedBox(height: 15),
                  _buildTextField('Site Name', _nameController, hint: 'Enter site name'),
                  SizedBox(height: 15),
                  _buildTextField('Description', _descriptionController, maxLines: 3, hint: 'Enter site description'),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final name = _nameController.text.trim();
                        final description = _descriptionController.text.trim();

                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter a site name')),
                          );
                          return;
                        }

                        await widget.onSave(name, description, _image);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.primaryColor1,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        _isEditing ? 'Update Site' : 'Add Site',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}