// lib/widgets/profile_image_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/user_service.dart';
import '../theme/color_extension.dart';

class ProfileImageWidget extends StatefulWidget {
  final String? imageUrl;
  final double size;
  final Function(String)? onImageUpdated;
  final bool editable;

  const ProfileImageWidget({
    Key? key,
    this.imageUrl,
    this.size = 100,
    this.onImageUpdated,
    this.editable = true,
  }) : super(key: key);

  @override
  _ProfileImageWidgetState createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  File? _imageFile;
  bool _isUploading = false;
  final UserService _userService = UserService();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _isUploading = true;
        });

        try {
          // final updatedUser = await _userService.uploadProfileImage(_imageFile!);
          //
          // if (widget.onImageUpdated != null && updatedUser['profile_image_url'] != null) {
          //   widget.onImageUpdated!(updatedUser['profile_image_url']);
          // }
          //
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Profile image updated successfully')),
          // );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile image')),
          );
        } finally {
          setState(() {
            _isUploading = false;
          });
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(widget.size / 2),
              child: _imageFile != null
                  ? Image.file(
                _imageFile!,
                width: widget.size,
                height: widget.size,
                fit: BoxFit.cover,
              )
                  : widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                  ? Image.network(
                widget.imageUrl!,
                width: widget.size,
                height: widget.size,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: widget.size,
                    height: widget.size,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: widget.size,
                    height: widget.size,
                    color: Colors.grey[200],
                    child: Icon(Icons.person, size: widget.size / 2),
                  );
                },
              )
                  : Image.asset(
                "assets/images/profile_photo.jpg",
                width: widget.size,
                height: widget.size,
                fit: BoxFit.cover,
              ),
            ),
            if (_isUploading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(widget.size / 2),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
            if (widget.editable && !_isUploading)
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: _pickImage,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: widget.size / 5,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (widget.editable)
          const SizedBox(height: 10),
        if (widget.editable && !_isUploading)
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: Icon(
              Icons.upload,
              color: Colors.white,
              size: 16,
            ),
            label: Text(
              "Upload Image",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
            backgroundColor: TColor.primaryColor1,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          ),
      ],
    );
  }
}